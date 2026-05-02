# SecureCode

A **GitHub repo template** for running the [OpenCode](https://opencode.ai) AI agent inside a hardened, disposable VS Code Dev Container.

The container is your blast radius. If you ever suspect compromise, destroy it and recreate it in seconds. Your host machine stays untouched.

---

## Security Model

| Threat | Mitigation |
|---|---|
| Container escape to host | VM-level isolation (Docker Desktop / Colima on macOS) |
| Filesystem tampering outside project | Only the project directory is bind-mounted; host home, SSH keys, and system files are inaccessible |
| Credential theft | No Git credentials, SSH keys, or API tokens are mounted into the container. Git operations stay on the host. |
| Privilege escalation | `--cap-drop=ALL`, `--read-only` root filesystem, `no-new-privileges`, no `sudo` |
| Persistence across recreations | All runtime state (`/tmp`, `~/.config`, `~/.local`, `~/.cache`) is stored in ephemeral tmpfs mounts |

**Tradeoffs accepted:**
- The container has unrestricted outbound internet (required for OpenCode to call LLM APIs and download packages).
- The container can read/write your project files via the bind-mount. Corruption is recoverable with git.
- OpenCode must be reconfigured after every container recreation (no persistent API keys in the container).

---

## Prerequisites

- **macOS** (or Linux)
- **Docker** — [Docker Desktop](https://www.docker.com/products/docker-desktop/) or [Colima](https://github.com/abiosoft/colima) (`brew install colima && colima start`)
- **VS Code** with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## Quick Start

1. **Create a new repo** from this GitHub template (click **"Use this template"**).
2. **Clone** your new repo locally.
3. **Run the initializer:**
   ```bash
   ./init.sh
   ```
   Select your language stack. The script configures the devcontainer and then deletes itself.
4. **Open in VS Code:**
   ```bash
   make shell
   # Then click "Reopen in Container" when prompted
   ```
5. **Start OpenCode** inside the container terminal:
   ```bash
   opencode
   ```

---

## Daily Workflow

### Two-Terminal Model

| Location | Purpose |
|---|---|
| **Host terminal** (e.g., iTerm) | `git clone`, `git commit`, `git push`, `git pull` |
| **VS Code integrated terminal (inside container)** | `opencode`, builds, tests, package managers |

**Never run git push from inside the container.** The container has no access to your GitHub credentials, which prevents a compromised agent from exfiltrating your PAT or pushing malicious code.

### Makefile Shortcuts

```bash
make shell   # Open this folder in VS Code
make nuke    # Destroy the devcontainer and prune unused Docker objects
```

---

## Destroy and Recreate

If you ever want a clean slate:

```bash
make nuke
# Then reopen in VS Code: Command Palette → "Dev Containers: Rebuild Container"
```

All container state is wiped. Your project files are safe on the host because they live in git and on your local disk.

---

## Supported Stacks

The initializer configures the appropriate Devcontainer Feature for your stack:

| Stack | Feature |
|---|---|
| Node.js / TypeScript | `ghcr.io/devcontainers/features/node:1` |
| Python | `ghcr.io/devcontainers/features/python:1` |
| Go | `ghcr.io/devcontainers/features/go:1` |
| Java | `ghcr.io/devcontainers/features/java:1` |
| Generic | No language tooling — just the hardened base |

You can add more features later by editing `.devcontainer/devcontainer.json`.

---

## Hardening Details

- **Base image:** `mcr.microsoft.com/devcontainers/base:ubuntu` (maintained by Microsoft)
- **Container user:** `vscode` (non-root, no `sudo`)
- **Capabilities:** All Linux capabilities dropped (`--cap-drop=ALL`)
- **Root FS:** Read-only with writable tmpfs overlays for `/tmp`, `/var/tmp`, `/run`, `~/.cache`, `~/.config`, `~/.local`
- **Port forwarding:** Explicit allow-list only (`3000`, `5000`, `8000`, `8080`)
- **Docker socket:** Not mounted. The container cannot spawn other containers.
- **VS Code extensions:** None pre-installed inside the container.

---

## Troubleshooting

**OpenCode says "command not found"**
> The `PATH` includes `~/.opencode/bin` via container environment. If a specific shell session cannot find it, run `export PATH="$HOME/.opencode/bin:$PATH"`.

**Permission denied when writing to `~/.config`**
> The `postCreateCommand` should fix tmpfs ownership on first start. If not, run: `sudo chown -R vscode:vscode ~/.config ~/.local ~/.cache` (note: `sudo` is removed in this image, so this should not happen).

**Port not accessible from host browser**
> Only ports `3000`, `5000`, `8000`, and `8080` are forwarded. If your app uses a different port, add it to `forwardPorts` in `.devcontainer/devcontainer.json` and rebuild the container.

---

## License

MIT
