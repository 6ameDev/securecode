#!/usr/bin/env bash
set -euo pipefail

echo "==================================="
echo "  SecureCode - Project Initializer"
echo "==================================="
echo ""
echo "Select your project stack:"
echo "  1) NodeJS"
echo "  2) Python"
echo "  3) Go"
echo "  4) Java"
echo "  5) Basic (no language tooling)"
echo ""

read -rp "Enter choice [1-5]: " choice

case $choice in
  1) image="mcr.microsoft.com/devcontainers/typescript-node"; user="node"; stack_name="NodeJS" ;;
  2) image="mcr.microsoft.com/devcontainers/python"; user="vscode"; stack_name="Python" ;;
  3) image="mcr.microsoft.com/devcontainers/go"; user="vscode"; stack_name="Go" ;;
  4) image="mcr.microsoft.com/devcontainers/java"; user="vscode"; stack_name="Java" ;;
  5) image="mcr.microsoft.com/devcontainers/base:ubuntu"; user="vscode"; stack_name="Basic" ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "Configuring for: $stack_name"

# Compute deterministic container name: sc-<project>-<hash>
# Hash is first 4 chars of SHA1 of the full absolute path
CONTAINER_NAME="sc-$(basename "$(pwd)")-$(echo -n "$(pwd)" | shasum | cut -c1-4)"

# Update the base devcontainer.json with stack-specific values
jq --arg image "$image" \
   --arg user "$user" \
   --arg name "$CONTAINER_NAME" \
   '.image = $image | .remoteUser = $user | .runArgs = ["--cap-drop=ALL", "--security-opt=no-new-privileges:true", "--name", $name]' \
   ".devcontainer/devcontainer.json" > ".devcontainer/devcontainer.json.tmp"

mv ".devcontainer/devcontainer.json.tmp" ".devcontainer/devcontainer.json"

# Clean up this script
rm -f init.sh

echo ""
echo "Done! Next steps:"
echo "  1. Open this folder in VS Code"
echo "  2. Run: 'Dev Containers: Reopen in Container' (or click the prompt)"
echo "  3. Once inside, run: opencode"
echo ""
echo "Remember: keep all git operations on your host machine."
