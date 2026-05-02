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
  1) stack="node" ;;
  2) stack="python" ;;
  3) stack="go" ;;
  4) stack="java" ;;
  5) stack="generic" ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "Configuring for: $stack"

# Copy the selected template into place
cp ".devcontainer/templates/$stack/devcontainer.json" ".devcontainer/devcontainer.json"

# Fix the Dockerfile path so it is correct relative to .devcontainer/devcontainer.json
sed -i.bak 's|"dockerfile": "../../Dockerfile"|"dockerfile": "Dockerfile"|g' ".devcontainer/devcontainer.json"
rm -f ".devcontainer/devcontainer.json.bak"

# Clean up template files and this script
rm -rf .devcontainer/templates/
rm -f init.sh

echo ""
echo "Done! Next steps:"
echo "  1. Open this folder in VS Code"
echo "  2. Run: 'Dev Containers: Reopen in Container' (or click the prompt)"
echo "  3. Once inside, run: opencode"
echo ""
echo "Remember: keep all git operations on your host machine."
