# Checks the repository docs against docs/agent-docs.md, plus the skill mirrors and the LF policy.
# Usage: pwsh -File scripts/check-docs.ps1
# Exit code 0 means every check passed.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

$skipDirs = @('.git', '.agents')
$mdFiles = Get-ChildItem -Path $root -Recurse -Filter *.md -File | Where-Object {
    $rel = $_.FullName.Substring($root.Length + 1)
    $parts = $rel -split '[\\/]'
    -not ($parts | Where-Object { $skipDirs -contains $_ })
} | Sort-Object FullName

$bareMarker = [regex]'^(?:[-*+]|\d+\.)$'
$heading = [regex]'^(#{1,6})\s'
$link = [regex]'\[[^\]]*\]\(([^)]+)\)'
$noop = [regex]'\b(make sure|be careful|it is important|please note|as needed)\b'
$machinePath = [regex]'(?i)(?<![A-Za-z0-9_])([A-Z]:[\\/][^\s<>|`]*|/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+)'

foreach ($file in $mdFiles) {
    $rel = $file.FullName.Substring($root.Length + 1) -replace '\\', '/'
    $text = [System.IO.File]::ReadAllText($file.FullName)
    $lines = $text -split "`r?`n"
    $inFence = $false
    $fences = 0
    $lastHeading = 0
    $links = $link.Matches($text)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line.TrimStart().StartsWith('```')) {
            $inFence = -not $inFence
            $fences++
            continue
        }
        if ($inFence) { continue }

        $trimmed = $line.Trim()
        if ($bareMarker.IsMatch($trimmed)) {
            $errors.Add("${rel}:$($i + 1): bare list marker")
        }

        $m = $heading.Match($line)
        if ($m.Success) {
            $level = $m.Groups[1].Value.Length
            if ($lastHeading -gt 0 -and $level -gt $lastHeading + 1) {
                $errors.Add("${rel}:$($i + 1): heading jump H$lastHeading -> H$level")
            }
            $lastHeading = $level
        }

        if ($rel -ne 'docs/agent-docs.md') {
            $match = $noop.Match($line)
            if ($match.Success) {
                $errors.Add("${rel}:$($i + 1): no-op phrase `"$($match.Groups[1].Value)`"")
            }
        }

        foreach ($machine in $machinePath.Matches($line)) {
            $errors.Add("${rel}:$($i + 1): machine path `"$($machine.Value)`"")
        }
    }

    if ($fences % 2 -ne 0) {
        $errors.Add("${rel}: unclosed code fence")
    }

    # A template pointer resolves in the generated folder, not in the skill folder.
    if ($rel -notmatch '^skills/[^/]+/templates/') {
        foreach ($m in $links) {
            $target = $m.Groups[1].Value.Trim()
            if ($target -match '^(https?:|mailto:|#)') { continue }
            $pathPart = ($target -split '#')[0]
            if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
            $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
            if (-not (Test-Path $resolved)) {
                $lineNo = ($text.Substring(0, $m.Index) -split "`n").Count
                $errors.Add("${rel}:${lineNo}: link target missing: $target")
            }
        }
    }
}

# Process documents: main workflows at workflows/*.md, sub-workflows at workflows/subflows/*.md.
# A main workflow owns pairs, support, conditions, and run state. A sub-workflow is reachable
# from a main workflow through ## Sub-flows tables and carries no pair or run data.
$workflowsRoot = Join-Path $root 'workflows'
if (Test-Path $workflowsRoot) {
    $mainWorkflowFiles = @(Get-ChildItem -Path $workflowsRoot -File -Filter *.md | Sort-Object FullName)
    $subflowsRoot = Join-Path $workflowsRoot 'subflows'
    $subflowFiles = @()
    if (Test-Path $subflowsRoot) {
        $subflowFiles = @(Get-ChildItem -Path $subflowsRoot -Recurse -File -Filter *.md | Sort-Object FullName)
    }

    $subflowHeadings = @('Entry', 'Roles', 'Sub-flows', 'Flow', 'Routes', 'Exit', 'Interactions used', 'Artifacts')
    $subflowForbiddenHeadings = @('Targets', 'Support', 'Conditions', 'Run state and artifacts', 'Caveats')
    foreach ($subflow in $subflowFiles) {
        $rel = $subflow.FullName.Substring($root.Length + 1) -replace '\\', '/'
        if ($subflow.DirectoryName -ne $subflowsRoot) {
            $errors.Add("${rel}: sub-workflow must sit directly under workflows/subflows/")
            continue
        }
        $text = [System.IO.File]::ReadAllText($subflow.FullName)
        foreach ($heading in $subflowHeadings) {
            if (-not [regex]::IsMatch($text, "(?m)^##\s+$([regex]::Escape($heading))\s*$")) {
                $errors.Add("${rel}: missing heading ## $heading")
            }
        }
        foreach ($heading in $subflowForbiddenHeadings) {
            if ([regex]::IsMatch($text, "(?m)^##\s+$([regex]::Escape($heading))\s*$")) {
                $errors.Add("${rel}: sub-workflow must not have ## $heading; the referencing main workflow owns it")
            }
        }
        $rolesSection = [regex]::Match($text, '(?ms)^##\s+Roles\s*$(.*?)(?=^##\s+|\z)')
        if ($rolesSection.Success) {
            foreach ($slugMatch in [regex]::Matches($rolesSection.Groups[1].Value, '(?m)^-\s+`([a-z0-9][a-z0-9-]*)`')) {
                $slug = $slugMatch.Groups[1].Value
                if (-not (Test-Path (Join-Path $root "roles/$slug/ROLE.md"))) {
                    $errors.Add("${rel}: Role slug not found under roles/: $slug")
                }
            }
        }
    }

    $nestedDocuments = @(Get-ChildItem -Path $workflowsRoot -Recurse -File -Filter *.md | Where-Object { $_.DirectoryName -ne $workflowsRoot })
    foreach ($file in $nestedDocuments) {
        $rel = $file.FullName.Substring($root.Length + 1) -replace '\\', '/'
        if ($rel -notmatch '^workflows/subflows/[^/]+\.md$') {
            $errors.Add("${rel}: process documents belong at workflows/*.md or workflows/subflows/*.md")
        }
    }

    # Build the ## Sub-flows graph from main workflows and sub-workflows.
    $workflowDocuments = @()
    foreach ($mainWorkflow in $mainWorkflowFiles) {
        $workflowDocuments += [pscustomobject]@{ File = $mainWorkflow; Kind = 'main' }
    }
    foreach ($subflow in $subflowFiles) {
        $workflowDocuments += [pscustomobject]@{ File = $subflow; Kind = 'sub-workflow' }
    }
    $workflowEdges = @{}
    foreach ($document in $workflowDocuments) {
        $rel = $document.File.FullName.Substring($root.Length + 1) -replace '\\', '/'
        $text = [System.IO.File]::ReadAllText($document.File.FullName)
        $section = [regex]::Match($text, '(?ms)^##\s+Sub-flows\s*$(.*?)(?=^##\s+|\z)')
        if (-not $section.Success) {
            if ($document.Kind -eq 'main') {
                $errors.Add("${rel}: missing heading ## Sub-flows")
            }
            $workflowEdges[$document.File.FullName] = @()
            continue
        }
        $sectionText = $section.Groups[1].Value
        $links = [regex]::Matches($sectionText, '\[[^\]]*\]\(([^)]+)\)')
        if ($links.Count -eq 0 -and $sectionText -notmatch '\(none\)') {
            $errors.Add("${rel}: ## Sub-flows must list a sub-workflow or say (none)")
        }
        $targets = @()
        foreach ($link in $links) {
            $target = $link.Groups[1].Value.Trim()
            if ($target -match '^(https?:|mailto:|#)') { continue }
            $pathPart = ($target -split '#')[0]
            if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
            $resolved = [System.IO.Path]::GetFullPath((Join-Path $document.File.DirectoryName $pathPart))
            $resolvedRel = [System.IO.Path]::GetRelativePath($root, $resolved) -replace '\\', '/'
            if ($resolvedRel -notmatch '^workflows/subflows/[^/]+\.md$') {
                $errors.Add("${rel}: Sub-flows entry is not a workflows/subflows/*.md file: $target")
                continue
            }
            if (-not (Test-Path $resolved)) {
                $errors.Add("${rel}: Sub-flows entry missing: $target")
                continue
            }
            $targets += $resolved
        }
        $workflowEdges[$document.File.FullName] = @($targets)
    }

    # Every sub-workflow must be reachable from a main workflow.
    $reachable = @{}
    $queue = [System.Collections.Generic.Queue[string]]::new()
    foreach ($mainWorkflow in $mainWorkflowFiles) {
        $reachable[$mainWorkflow.FullName] = $true
        $queue.Enqueue($mainWorkflow.FullName)
    }
    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        foreach ($next in $workflowEdges[$current]) {
            if (-not $reachable.ContainsKey($next)) {
                $reachable[$next] = $true
                $queue.Enqueue($next)
            }
        }
    }
    foreach ($subflow in $subflowFiles) {
        if (-not $reachable.ContainsKey($subflow.FullName)) {
            $rel = $subflow.FullName.Substring($root.Length + 1) -replace '\\', '/'
            $errors.Add("${rel}: sub-workflow is not reachable from any main workflow's ## Sub-flows tables")
        }
    }

    # No cycles across Sub-flows edges.
    $visitState = @{}
    function Test-WorkflowCycle([string]$node) {
        $visitState[$node] = 1
        foreach ($next in $workflowEdges[$node]) {
            if ($visitState[$next] -eq 1) { return $true }
            if (-not $visitState.ContainsKey($next)) {
                if (Test-WorkflowCycle $next) { return $true }
            }
        }
        $visitState[$node] = 2
        return $false
    }
    $cycleFound = $false
    foreach ($document in $workflowDocuments) {
        if (-not $visitState.ContainsKey($document.File.FullName)) {
            if (Test-WorkflowCycle $document.File.FullName) { $cycleFound = $true; break }
        }
    }
    if ($cycleFound) {
        $errors.Add("workflows/: ## Sub-flows references contain a cycle")
    }
}

$roleCount = 0
$rolesRoot = Join-Path $root 'roles'
if (Test-Path $rolesRoot) {
    $stableHeadings = @('Purpose', 'Boundaries', 'Required reading')
    $playbookHeadings = @('Responsibilities', 'Steps', 'Checklists', 'Handoffs', 'When stuck', 'Notes')
    $roleRequired = @(
        @{ Label = 'title'; Pattern = '(?m)^#\s+\S' },
        @{ Label = 'slug line'; Pattern = '(?m)^-\s+\*\*slug:\*\*' },
        @{ Label = 'layout line'; Pattern = '(?m)^-\s+\*\*layout:\*\*' }
    )

    foreach ($roleDir in Get-ChildItem -Path $rolesRoot -Directory) {
        $roleCount++
        $roleRel = "roles/$($roleDir.Name)/ROLE.md"
        $rolePath = Join-Path $roleDir.FullName 'ROLE.md'
        if (-not (Test-Path $rolePath)) {
            $errors.Add("role card missing: $roleRel")
            continue
        }
        $roleText = [System.IO.File]::ReadAllText($rolePath)
        foreach ($required in $roleRequired) {
            if (-not [regex]::IsMatch($roleText, $required.Pattern)) {
                $errors.Add("${roleRel}: missing $($required.Label)")
            }
        }
        foreach ($heading in $stableHeadings) {
            if (-not [regex]::IsMatch($roleText, "(?m)^##\s+$([regex]::Escape($heading))\s*$")) {
                $errors.Add("${roleRel}: missing heading ## $heading")
            }
        }
        if ($roleText -notmatch 'workflows/') {
            $errors.Add("${roleRel}: no workflows/ pointer")
        }

        $merged = [regex]::IsMatch($roleText, '(?m)^-\s+\*\*layout:\*\*\s*Role-merged')
        if ($merged) {
            foreach ($heading in $playbookHeadings) {
                if (-not [regex]::IsMatch($roleText, "(?m)^###\s+$([regex]::Escape($heading))\s*$")) {
                    $errors.Add("${roleRel}: Role-merged missing heading ### $heading")
                }
            }
        }
        else {
            $playbookRel = "roles/$($roleDir.Name)/PLAYBOOK.md"
            $playbookPath = Join-Path $roleDir.FullName 'PLAYBOOK.md'
            if (-not (Test-Path $playbookPath)) {
                $errors.Add("role card missing: $playbookRel")
                continue
            }
            $playbookText = [System.IO.File]::ReadAllText($playbookPath)
            if (-not [regex]::IsMatch($playbookText, '(?m)^slug:')) {
                $errors.Add("${playbookRel}: missing slug line")
            }
            foreach ($heading in $playbookHeadings) {
                if (-not [regex]::IsMatch($playbookText, "(?m)^##\s+$([regex]::Escape($heading))\s*$")) {
                    $errors.Add("${playbookRel}: missing heading ## $heading")
                }
            }
        }
    }
}

$attributes = Join-Path $root '.gitattributes'

function Get-NormalizedHash([string]$path) {
    # Compare content, not line endings: a checkout may hold CRLF while its mirror holds LF.
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        return [System.BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-', '')
    }
    finally {
        $sha.Dispose()
    }
}

foreach ($skillDir in Get-ChildItem -Path (Join-Path $root 'skills') -Directory) {
    $name = $skillDir.Name
    $mirror = Join-Path $root ".agents/skills/$name"
    if (-not (Test-Path $mirror)) {
        $errors.Add("mirror missing: .agents/skills/$name")
        continue
    }
    $sourceFiles = Get-ChildItem -Path $skillDir.FullName -Recurse -File
    $mirrorFiles = Get-ChildItem -Path $mirror -Recurse -File
    $sourceRel = $sourceFiles | ForEach-Object { $_.FullName.Substring($skillDir.FullName.Length + 1) } | Sort-Object
    $mirrorRel = $mirrorFiles | ForEach-Object { $_.FullName.Substring($mirror.Length + 1) } | Sort-Object
    if (Compare-Object $sourceRel $mirrorRel) {
        $errors.Add("mirror file list differs: skills/$name vs .agents/skills/$name")
        continue
    }
    foreach ($sourceFile in $sourceFiles) {
        $relPath = $sourceFile.FullName.Substring($skillDir.FullName.Length + 1)
        $mirrorFile = Join-Path $mirror $relPath
        if ((Get-NormalizedHash $sourceFile.FullName) -ne (Get-NormalizedHash $mirrorFile)) {
            $errors.Add("mirror content differs: skills/$name/$relPath")
        }
    }
}

if ((Test-Path $attributes) -and ((Get-Content $attributes -Raw) -match 'eol=lf')) {
    $eol = & git -C $root ls-files --eol
    $badEol = $eol | Where-Object { $_ -match '(^|\s)(i/crlf|w/crlf|w/mixed)(\s|$)' }
    foreach ($line in $badEol) {
        $errors.Add("line endings: $line")
    }
}

# The PR template keeps its three sections in the order the pr skill expects.
$prTemplatePath = Join-Path $root '.github/pull_request_template.md'
if (Test-Path $prTemplatePath) {
    $expectedSections = @('Summary', 'Evidence', 'Merge Danger')
    $actualSections = @()
    foreach ($line in [System.IO.File]::ReadAllLines($prTemplatePath)) {
        if ($line -match '^##\s+(.+?)\s*$') { $actualSections += $Matches[1] }
    }
    if (($actualSections -join '|') -ne ($expectedSections -join '|')) {
        $errors.Add("PR template sections: expected [$($expectedSections -join ', ')], found [$($actualSections -join ', ')]")
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Output "ERROR $_" }
    Write-Output "$($errors.Count) problem(s) found"
    exit 1
}

Write-Output "ok: $($mdFiles.Count) markdown files, $roleCount role cards, $(@(Get-ChildItem -Path (Join-Path $root 'skills') -Directory).Count) skill mirrors, line endings"
exit 0
