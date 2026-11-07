Report only this session. Do not describe another product or another environment.

Judge this session's harness and environment yourself. The method below is a suggestion. When you cannot tell, write uncertain and name the missing fact.

Suggested method:

- Harness: the product name written in this session's system or developer instructions. "You operate in Cursor" means Cursor. A model name is not a harness. If no product name is written, the harness is uncertain.
- Environment: where this session is attached, not where the model is hosted. A remote model API does not make the environment Cloud agent. Use the first rule that matches:
  1. Cloud agent — the instructions say this agent runs on a remote machine, VM, or cloud worker, and this chat is not inside the human's editor and not a terminal on the human's machine.
  2. Local CLI — this session's surface is a terminal on the human's machine, and no editor workspace is attached to this chat.
  3. Local IDE chat — this chat is attached to an editor workspace (a workspace path and file tools on that workspace). A shell on that same machine does not make it Local CLI.
- If none match, the environment is uncertain.

Judge each interaction from tools and actions available now. The label is exactly one of supported, unsupported, uncertain. Then one sentence why.

- relay: a human in this session can carry a brief to another role
- switch: this same session can load another role card and continue as that role
- spawn: this session can start another agent bound to a role
- parallel: more than one role agent can run at the same time
- resume: this session can continue a specific earlier agent
- message: one agent can deliver to another agent without a human
- artifact: another role can read a file this session writes in the repo
- gate: this session can stop until a human gives an explicit yes
- slash `{{COMMAND}}`: this session can invoke that command
- subagent-depth: a sub-agent created here can create its own sub-agent. Say how many further levels. Use `none` when it cannot. Use `uncertain` when you cannot tell
- subagent-peers: sub-agents can communicate with each other, not only back to the session that created them
- main-peers: this main session can communicate with another main session without a human carrying the message. For a chat product, that is one chat session reaching another chat session. For a bot product, that is one bot reaching another bot

Reply in this shape and no other prose:

Harness: <name or uncertain> — <why>
Environment: <name or uncertain> — <why>
relay: supported|unsupported|uncertain — <why>
switch: supported|unsupported|uncertain — <why>
spawn: supported|unsupported|uncertain — <why>
parallel: supported|unsupported|uncertain — <why>
resume: supported|unsupported|uncertain — <why>
message: supported|unsupported|uncertain — <why>
artifact: supported|unsupported|uncertain — <why>
gate: supported|unsupported|uncertain — <why>
slash {{COMMAND}}: supported|unsupported|uncertain — <why>
subagent-depth: <number>|none|uncertain — <why>
subagent-peers: supported|unsupported|uncertain — <why>
main-peers: supported|unsupported|uncertain — <why>
