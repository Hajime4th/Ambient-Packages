#!/usr/bin/env bash
# Add Ambient's signed browser repository and install the browser.
set -euo pipefail
if [ "$(id -u)" -eq 0 ]; then
  echo 'Run this script as your normal desktop user, without sudo.' >&2
  exit 1
fi
. /etc/os-release
if [ "${ID:-}" != ubuntu ] || [ "${VERSION_ID:-}" != 26.04 ]; then
  echo 'This repository currently supports Ubuntu 26.04.' >&2
  exit 1
fi
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
TASK_DIR="$(mktemp -d)"
trap 'rm -rf "$TASK_DIR"' EXIT
REPO_URL='https://hajime4th.github.io/Ambient-Packages/browser'
curl --fail --show-error --silent --location "$REPO_URL/ambient-browser.gpg" -o "$TASK_DIR/ambient-browser.gpg"
mkdir -m 700 "$TASK_DIR/gnupg"
FINGERPRINT="$(gpg --homedir "$TASK_DIR/gnupg" --batch --with-colons --show-keys "$TASK_DIR/ambient-browser.gpg" | awk -F: '$1=="fpr" {print $10; exit}')"
if [ "$FINGERPRINT" != '854474C654147D0B13CDB52BE42E236F04EA0A1F' ]; then
  echo 'Repository signing key did not match the expected fingerprint.' >&2
  exit 1
fi
sudo install -d -m 755 /etc/apt/keyrings
sudo install -m 644 "$TASK_DIR/ambient-browser.gpg" /etc/apt/keyrings/ambient-browser.gpg
cat > "$TASK_DIR/ambient-browser.sources" <<SOURCES
Types: deb
URIs: $REPO_URL/
Suites: ./
Signed-By: /etc/apt/keyrings/ambient-browser.gpg
SOURCES
sudo install -m 644 "$TASK_DIR/ambient-browser.sources" /etc/apt/sources.list.d/ambient-browser.sources
sudo apt-get update
sudo apt-get install -y ambient-browser
ambient-browser-use-system
