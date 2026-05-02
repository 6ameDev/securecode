# SecureCode

A hardened, disposable development container for AI-assisted coding. If anything goes wrong inside, destroy it and start fresh in seconds. Your host machine and git history stay untouched.

## What threats does it protect against?

| Threat | What SecureCode does |
|---|---|
| Malicious dependencies trying to escape the container | Container runs with dropped capabilities and privilege restrictions |
| Code or credentials leaking from your host | Only your project folder is visible inside; SSH keys, GitHub tokens, and host files are never mounted |
| Malicious code persisting across sessions | One command destroys the container and all its state |
| Your git history being tampered with | The `.git` directory is mounted read-only from the container |

## Supported stacks

Pick your language during setup. SecureCode pulls the official Microsoft devcontainer image for your stack.

- Node.js / TypeScript
- Python
- Go
- Java
- Basic (no language tooling)

## Prerequisites

- macOS or Linux
- Docker Desktop or Colima
- VS Code with the Dev Containers extension

## Quick start

```bash
# 1. Run the initializer and pick your stack
./init.sh

# 2. Open in VS Code
make shell
# Click "Reopen in Container" when prompted

# 3. Start coding with your AI assistant
opencode
```

## Daily workflow

**Host terminal:** `git clone`, `commit`, `push`, `pull`

**Container terminal:** `opencode`, builds, tests, package installs

**Never run git push from inside the container.** The container has no access to your GitHub credentials, which prevents a compromised agent from pushing malicious code or exfiltrating your tokens.

## Makefile commands

```bash
make init        # Run the stack selector
make shell       # Open in VS Code
make nuke        # Destroy container and show git status
make nuke-force  # Destroy container and hard-reset git workspace
```

Use `make nuke` when you want a clean container. If git shows uncommitted changes, it will warn you before touching anything. Use `make nuke-force` when you are certain you want to discard all workspace changes and start completely fresh.

## Supported AI tools

Currently ships with [OpenCode](https://opencode.ai) pre-configured. OpenCode installs automatically when the container starts.

## Troubleshooting

**OpenCode says "command not found"**

The PATH includes `~/.opencode/bin` via container environment. If a specific shell session cannot find it, run `export PATH="$HOME/.opencode/bin:$PATH"`.

**Port not accessible from host browser**

Only ports `3000`, `5000`, `8000`, and `8080` are forwarded. If your app uses a different port, add it to `forwardPorts` in `.devcontainer/devcontainer.json` and rebuild the container.

## License

MIT
