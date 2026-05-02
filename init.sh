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
echo "  5) Generic (no language tooling)"
echo ""

read -rp "Enter choice [1-5]: " choice

case $choice in
  1) stack="node"; stack_name="NodeJS" ;;
  2) stack="python"; stack_name="Python" ;;
  3) stack="go"; stack_name="Go" ;;
  4) stack="java"; stack_name="Java" ;;
  5) stack="generic"; stack_name="Generic" ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "Configuring for: $stack"

# Update the base devcontainer.json with stack-specific values
if [ "$stack" = "generic" ]; then
  jq --arg name "SecureCode - ${stack_name}" \
     '.name = $name | del(.features)' \
     ".devcontainer/devcontainer.json" > ".devcontainer/devcontainer.json.tmp"
else
  jq --arg name "SecureCode - ${stack_name}" \
     --arg stack "$stack" \
     '.name = $name | .features = { ("ghcr.io/devcontainers/features/" + $stack + ":1"): {} }' \
     ".devcontainer/devcontainer.json" > ".devcontainer/devcontainer.json.tmp"
fi

mv ".devcontainer/devcontainer.json.tmp" ".devcontainer/devcontainer.json"

# Clean up this script
# rm -f init.sh

echo ""
echo "Done! Next steps:"
echo "  1. Open this folder in VS Code"
echo "  2. Run: 'Dev Containers: Reopen in Container' (or click the prompt)"
echo "  3. Once inside, run: opencode"
echo ""
echo "Remember: keep all git operations on your host machine."
