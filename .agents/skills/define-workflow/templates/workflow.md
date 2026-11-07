# Workflow

End-to-end collaboration among Roles. Role-local craft stays on the Role card.

## Targets

| Harness | Environment |
|---|---|
{{TARGETS}}

## Support

Each cell is `supported`, `unsupported`, or `uncertain`, except `subagent-depth`, which is `none`, a number of further levels a sub-agent can create, or `uncertain`. Slash rows name the command.

| Interaction | {{PAIR_COLUMNS}} |
|---|---|
| relay | {{RELAY}} |
| switch | {{SWITCH}} |
| spawn | {{SPAWN}} |
| parallel | {{PARALLEL}} |
| resume | {{RESUME}} |
| message | {{MESSAGE}} |
| artifact | {{ARTIFACT}} |
| gate | {{GATE}} |
| slash `{{COMMAND}}` | {{SLASH}} |
| subagent-depth | {{SUBAGENT_DEPTH}} |
| subagent-peers | {{SUBAGENT_PEERS}} |
| main-peers | {{MAIN_PEERS}} |

## Conditions

| Pair | Mode | Human at handoff | Shared repo |
|---|---|---|---|
| {{PAIR}} | {{MODE}} | {{ATTENDANT}} | {{SHARED_REPO}} |

## Roles

{{ROLES}}

## Flow

{{FLOW}}

## Routes

### `{{SLUG}}` handoff

| When | Next | Interaction |
|---|---|---|
| {{WHEN}} | {{NEXT}} | {{INTERACTION}} |

### `{{SLUG}}` when stuck

| When | Raise to | Interaction |
|---|---|---|
| {{WHEN}} | {{RAISE_TO}} | {{INTERACTION}} |

## Run state and artifacts

{{RUN_STATE}}

## Caveats

{{CAVEATS}}
