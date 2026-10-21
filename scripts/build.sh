#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
if [[ "$(uname -s)" != Darwin ]]; then
  echo "The menu bar app must be built on macOS." >&2
  exit 1
fi
bash "$ROOT/scripts/prepare-source.sh"
(
  cd "$ROOT/.build/upstream"
  CODEXBAR_SIGNING=adhoc ./Scripts/package_app.sh release
)
bash "$ROOT/scripts/package-release.sh" "$ROOT/.build/upstream/CodexBar.app"
