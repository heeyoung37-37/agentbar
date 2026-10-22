#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
source "$ROOT/upstream.env"
INPUT="${1:?Usage: package-release.sh /path/to/CodexBar.app}"
DIST="$ROOT/dist"
if [[ ! -x "$INPUT/Contents/MacOS/CodexBar" ]]; then
  echo "A built CodexBar app is required." >&2
  exit 1
fi
if [[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$INPUT/Contents/Info.plist")" != com.steipete.codexbar ]]; then
  echo "Unexpected input bundle identifier." >&2
  exit 1
fi
ARCH=$(lipo -archs "$INPUT/Contents/MacOS/CodexBar")
case "$ARCH" in
  arm64|x86_64) ;;
  'x86_64 arm64'|'arm64 x86_64') ARCH=universal ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac
NAME="AgentBar-$AGENTBAR_VERSION-macos-$ARCH"
mkdir -p "$DIST"
if [[ -e "$DIST/$NAME.zip" ]]; then
  echo "Release output already exists: $DIST/$NAME.zip" >&2
  exit 1
fi
# Stage outside synced Documents folders: Finder metadata can invalidate signing.
WORK=$(mktemp -d "${TMPDIR:-/tmp}/agentbar-package.XXXXXX")
STAGE="$WORK/$NAME"
mkdir -p "$STAGE"
APP="$STAGE/AgentBar.app"
ditto --norsrc --noextattr "$INPUT" "$APP"
python3 - "$APP" "$AGENTBAR_VERSION" "$UPSTREAM_COMMIT" "$ROOT/patches/agentbar.patch" <<'PY'
import hashlib, json, plistlib, sys
from pathlib import Path
app = Path(sys.argv[1])
info = app / 'Contents/Info.plist'
data = plistlib.loads(info.read_bytes())
upstream_version = data['CFBundleShortVersionString']
data['CFBundleName'] = 'AgentBar'
data['CFBundleShortVersionString'] = sys.argv[2]
data['CFBundleVersion'] = sys.argv[2]
data['CFBundleDisplayName'] = 'AgentBar'
data['SUFeedURL'] = ''
data['SUEnableAutomaticChecks'] = False
data['SUAutomaticallyUpdate'] = False
info.write_bytes(plistlib.dumps(data, sort_keys=False))
manifest = {
    'agentbar_version': sys.argv[2],
    'upstream_version': upstream_version,
    'upstream_commit': sys.argv[3],
    'agentbar_patch_sha256': hashlib.sha256(Path(sys.argv[4]).read_bytes()).hexdigest(),
    'input_executable_sha256': hashlib.sha256((app / 'Contents/MacOS/CodexBar').read_bytes()).hexdigest(),
    'signing': 'ad-hoc', 'notarized': False,
}
(app / 'Contents/Resources/AgentBarRelease.json').write_text(json.dumps(manifest, indent=2) + '\n')
PY
cp "$ROOT/scripts/apply-preset.sh" "$STAGE/Apply AgentBar Preset.command"
chmod +x "$STAGE/Apply AgentBar Preset.command"
cp "$ROOT/README.md" "$ROOT/CHANGELOG.md" "$ROOT/LICENSE" "$ROOT/THIRD_PARTY_NOTICES.md" "$STAGE/"
python3 - "$ROOT/licenses" "$STAGE/licenses" <<'PY'
from pathlib import Path
import sys
source, destination = map(Path, sys.argv[1:])
destination.mkdir()
for license_file in source.iterdir():
    if license_file.is_file():
        (destination / license_file.name).write_bytes(license_file.read_bytes())
PY
mkdir -p "$STAGE/docs"
cp "$ROOT/docs/menubar.png" "$STAGE/docs/menubar.png"
# Remove only signing-incompatible file metadata from our staging copy.
# Do not remove quarantine flags or modify the installed source application.
xattr -r -d com.apple.FinderInfo "$APP" 2>/dev/null || true
xattr -r -d com.apple.ResourceFork "$APP" 2>/dev/null || true
codesign --force --sign - --preserve-metadata=identifier,entitlements,flags --timestamp=none "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"
ditto -c -k --norsrc --noextattr --keepParent "$STAGE" "$DIST/$NAME.zip"
(cd "$DIST" && shasum -a 256 "$NAME.zip" > SHA256SUMS)
echo "Release ready: $DIST/$NAME.zip"
echo "Staged app: $APP"
