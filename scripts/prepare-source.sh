#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
source "$ROOT/upstream.env"
ARCHIVE="$ROOT/.build/CodexBar-$UPSTREAM_COMMIT.tar.gz"
SOURCE="$ROOT/.build/upstream"
PATCH="$ROOT/patches/agentbar.patch"
PATCH_SHA=$(shasum -a 256 "$PATCH" | awk '{print $1}')
MARKER="$UPSTREAM_COMMIT:$PATCH_SHA"
if [[ -d "$SOURCE" ]]; then
  if [[ -f "$SOURCE/.agentbar-source" ]] && [[ "$(cat "$SOURCE/.agentbar-source")" == "$MARKER" ]]; then
    echo "Patched source is ready: $SOURCE"
    exit 0
  fi
  echo "Source directory already exists without the matching marker: $SOURCE" >&2
  echo "Move it aside before reconstructing a different source revision." >&2
  exit 1
fi
mkdir -p "$ROOT/.build"
if [[ ! -f "$ARCHIVE" ]]; then
  curl --fail --location --silent --show-error \
    "https://codeload.github.com/steipete/CodexBar/tar.gz/$UPSTREAM_COMMIT" -o "$ARCHIVE"
fi
printf '%s  %s\n' "$UPSTREAM_ARCHIVE_SHA256" "$ARCHIVE" | shasum -a 256 --check
mkdir -p "$SOURCE"
tar -xzf "$ARCHIVE" --strip-components=1 -C "$SOURCE"
(cd "$SOURCE" && patch --dry-run -p1 < "$PATCH" && patch -p1 < "$PATCH")
printf '%s\n' "$MARKER" > "$SOURCE/.agentbar-source"
echo "Patched source is ready: $SOURCE"
