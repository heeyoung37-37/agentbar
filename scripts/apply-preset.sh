#!/bin/bash
set -euo pipefail
DOMAIN=com.steipete.codexbar
LAYOUT='{"codex":{"lines":[[{"providerName":{}},{"space":{}},{"lanePercent":{"lane":"secondary"}},{"space":{}},{"progressBar":{"window":"weekly"}}]]},"claude":{"lines":[[{"providerName":{}},{"space":{}},{"lanePercent":{"lane":"secondary"}},{"space":{}},{"progressBar":{"window":"weekly"}}]]}}'
if [[ "${1:-}" == --dry-run ]]; then
  echo "AgentBar preset: Codex / Claude, weekly remaining %, monochrome bars."
  echo "Fixed columns with monospaced digits; 2-point gutters."
  echo "Enable codex + claude providers; disable upstream automatic updates."
  echo "Writes display settings in $DOMAIN; no credentials or usage probes."
  exit 0
fi
APP="${1:-/Applications/AgentBar.app}"
if [[ ! -d "$APP" ]]; then
  APP="$(cd "$(dirname "$0")" && pwd)/AgentBar.app"
fi
if [[ ! -x "$APP/Contents/Helpers/CodexBarCLI" ]] || \
   [[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Contents/Info.plist" 2>/dev/null)" != "$DOMAIN" ]]; then
  echo "Move AgentBar.app into /Applications first, or pass its path." >&2
  exit 1
fi
if pgrep -x CodexBar >/dev/null; then
  echo "Quit CodexBar / AgentBar from its menu, then run this preset again." >&2
  exit 1
fi
# These commands enable providers only. They do not fetch usage or read credentials.
"$APP/Contents/Helpers/CodexBarCLI" config enable --provider codex
"$APP/Contents/Helpers/CodexBarCLI" config enable --provider claude
defaults write "$DOMAIN" mergeIcons -bool true
defaults write "$DOMAIN" mergeIconsStacked -bool true
defaults write "$DOMAIN" mergeIconStackedTopProvider -string codex
defaults write "$DOMAIN" mergeIconStackedBottomProvider -string claude
defaults write "$DOMAIN" usageBarsShowUsed -bool false
defaults write "$DOMAIN" menuBarColorByProvider -bool false
defaults write "$DOMAIN" menuBarLayoutMonospacedDigits -bool true
defaults write "$DOMAIN" menuBarLayoutSize -string large
defaults write "$DOMAIN" menuBarLayoutGap -string regular
defaults write "$DOMAIN" menuBarMetricPreferences -dict codex weekly claude weekly
HEX=$(printf '%s' "$LAYOUT" | od -An -v -tx1 | tr -d ' \n')
defaults write "$DOMAIN" menuBarLayoutOverridesV5 -data "$HEX"
defaults write "$DOMAIN" tokenCostUsageEnabled -bool true
defaults write "$DOMAIN" costSummaryDisplayStyle -string both
defaults write "$DOMAIN" SUEnableAutomaticChecks -bool false
defaults write "$DOMAIN" SUAutomaticallyUpdate -bool false
echo "AgentBar preset applied. Open AgentBar.app and connect your own accounts."
