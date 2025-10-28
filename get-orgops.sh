#!/usr/bin/env bash
set -e

VERSION="v1.0.0"
OWNER="OrgOps"
REPO="core"  # updated from "releases" to "core"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture names
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

BINARY_NAME="orgops-${OS}-${ARCH}"
DOWNLOAD_URL="https://github.com/${OWNER}/${REPO}/releases/download/${VERSION}/${BINARY_NAME}"
INSTALL_PATH="/usr/local/bin/orgops"

echo "📦 Installing OrgOps ${VERSION} for ${OS}-${ARCH}"
echo "⬇️  Downloading from ${DOWNLOAD_URL}"

curl -L --fail "${DOWNLOAD_URL}" -o "${INSTALL_PATH}"
chmod +x "${INSTALL_PATH}"

echo "✅ OrgOps installed successfully!"
"${INSTALL_PATH}" --version || true
