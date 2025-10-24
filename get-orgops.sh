#!/usr/bin/env bash
# ============================================================
#  OrgOps Installer Script
#  Version: 1.0.0
#  Author:  OrgOps (www.orgops.org)
# ============================================================

set -euo pipefail

ORGOPS_VERSION="1.0.0"
BASE_URL="https://www.orgops.org/downloads"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"
BINARY_PATH="${TMP_DIR}/orgops"

# --------------------------
#  Detect OS & architecture
# --------------------------
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64|amd64) ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: ${ARCH}"; exit 1 ;;
esac

echo "📦 Installing OrgOps v${ORGOPS_VERSION} for ${OS}-${ARCH}"

# --------------------------
#  Determine binary URL
# --------------------------
BINARY_NAME="orgops-${OS}-${ARCH}"
BINARY_URL="${BASE_URL}/${BINARY_NAME}"

# Optional: checksum file
CHECKSUM_URL="${BASE_URL}/checksums.txt"

# --------------------------
#  Download binary
# --------------------------
echo "⬇️  Downloading ${BINARY_URL}"
curl -fsSL -o "${BINARY_PATH}" "${BINARY_URL}"

# --------------------------
#  Verify checksum (if file exists)
# --------------------------
if curl --output /dev/null --silent --head --fail "${CHECKSUM_URL}"; then
  echo "🔍 Verifying checksum..."
  curl -fsSL -o "${TMP_DIR}/checksums.txt" "${CHECKSUM_URL}"
  grep "${BINARY_NAME}" "${TMP_DIR}/checksums.txt" | shasum -a 256 -c -
else
  echo "⚠️  No checksum file found — skipping verification."
fi

# --------------------------
#  Install binary
# --------------------------
chmod +x "${BINARY_PATH}"

if [ ! -w "${INSTALL_DIR}" ]; then
  echo "🛠️  Requires sudo to install in ${INSTALL_DIR}"
  sudo mv "${BINARY_PATH}" "${INSTALL_DIR}/orgops"
else
  mv "${BINARY_PATH}" "${INSTALL_DIR}/orgops"
fi

# --------------------------
#  Final checks
# --------------------------
if command -v orgops >/dev/null 2>&1; then
  echo "✅ OrgOps v${ORGOPS_VERSION} installed successfully!"
  echo "➡️  Run: orgops --help"
else
  echo "⚠️  Installed binary not found in PATH. Add ${INSTALL_DIR} to your PATH."
fi