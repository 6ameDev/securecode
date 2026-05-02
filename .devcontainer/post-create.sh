#!/usr/bin/env bash
set -euo pipefail

mkdir -p /home/vscode/.config /home/vscode/.local /home/vscode/.cache
chown -R vscode:vscode /home/vscode/.config /home/vscode/.local /home/vscode/.cache
