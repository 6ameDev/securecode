# Security Backlog

## Removed tmpfs mounts (2026-05-03)
The following tmpfs mounts were removed to simplify the devcontainer configuration.
They can be reintroduced if security or operational issues arise.

- `/tmp` - prevents persistent malware drops and symlink attacks in temp space
- `/var/tmp` - persistent temp space for larger files
- `/run` - ensures clean runtime state on container restart
- `/home/vscode/.cache` - ephemeral user cache (already working without tmpfs)
- `/home/vscode/.config` - ephemeral user config (already working without tmpfs)
- `/home/vscode/.local` - ephemeral user local data (already working without tmpfs)
- `/home/vscode/.vscode-server` - VS Code server installation directory
- `/var/devcontainer` - VS Code internal setup markers

## Rationale for removal
Without `--read-only`, tmpfs mounts for home directories caused `chown` permission
failures because `postCreateCommand` runs as `remoteUser` (vscode), not root.
Standard system tmpfs mounts were removed as part of a minimal-privilege experiment.

## Sudoers file in devcontainer images (2026-05-03)

Microsoft devcontainer images ship with `/etc/sudoers.d/vscode` granting
passwordless sudo to the `vscode` user.

**Mitigation:** `--security-opt=no-new-privileges:true` completely blocks
sudo from functioning at the kernel level. The sudoers file exists but is
rendered harmless.

**Status:** Runtime removal is not feasible without a Dockerfile (lifecycle
scripts run as `remoteUser`, not root). The `--no-new-privileges` flag is the
effective mitigation.
