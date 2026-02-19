#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

NAME="$(node -p "require('./package.json').name")"
VERSION="$(node -p "require('./package.json').version")"
OUT_FILE="${NAME}-${VERSION}.vsix"

echo "Packaging ${OUT_FILE}..."
npx --yes @vscode/vsce package -o "$OUT_FILE"
echo "Done: ${OUT_FILE}"
