FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Remove sudo access from the vscode user to enforce least privilege
RUN rm -f /etc/sudoers.d/vscode

# Install OpenCode as the vscode user so it lands in the correct home directory
USER vscode
ENV HOME=/home/vscode
RUN curl -fsSL https://opencode.ai/install | bash

# Ensure the opencode binary is on PATH for all shells (including non-interactive)
ENV PATH="/home/vscode/.opencode/bin:${PATH}"

# Switch back to root so that VS Code's postCreateCommand runs with elevated
# permissions (needed to fix tmpfs mount ownership before the vscode session starts)
USER root

# Set the working directory for the container
WORKDIR /workspaces
