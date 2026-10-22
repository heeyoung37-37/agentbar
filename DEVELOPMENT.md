# Development

AgentBar is a compact patch distribution of CodexBar, not a separately implemented usage client.

## Build

Use macOS 14+, full Xcode with Swift 6.2+ selected by `xcode-select`, and Python 3. Network access is needed for the pinned source and SwiftPM dependencies.

```bash
bash scripts/prepare-source.sh
bash scripts/build.sh
```

The default build targets the host architecture; `ARCHES="arm64 x86_64" bash scripts/build.sh` requests a universal build. Only the initial arm64 binary has been validated for this release. The output is `dist/AgentBar-0.1.1-macos-<arch>.zip` and `dist/SHA256SUMS`.

`prepare-source.sh` checks the upstream archive SHA-256 and applies `patches/agentbar.patch`. It never touches installed apps or credentials. The complete patched source is in `.build/upstream/`.

`package-release.sh /path/to/CodexBar.app` repackages an already built app. It changes the display name, disables upstream automatic updates, retains the original bundle identifiers for compatibility, and applies an ad-hoc signature. Release v0.1.0 repackaged a previously validated local build. Release v0.1.1 is rebuilt from the pinned source and the updated patch. The app is not notarized. The release manifest records the upstream commit, patch SHA-256, and input executable SHA-256.

## Claude connection recovery

The web importer retains permission-denied and unreadable-store errors instead of converting every failure to a missing session. Safari metadata probes detect directory denial even when store discovery hides the file. A new access failure takes precedence over an older cached-cookie authentication error.

The Claude runtime schedules a single background retry after 15/30/60/120 seconds, capped at 300 seconds. HTTP 429 and Cloudflare challenges defer pending fast retries to 300 seconds. Successful refresh, disablement, and provider configuration changes cancel recovery. Retry requests re-enter the existing account-aware refresh coordinator under the background interaction context; they do not override Keychain consent gates. Retries continue even when the normal periodic refresh setting is manual.

The two new messages use English fallback in other locale catalogs; English and Korean are provided explicitly. An access error opens Claude settings rather than offering a misleading re-login action.

## Validation

- Original local build (2026-10-16): 117 focused tests in 6 suites, lint, release packaging and smoke checks passed.
- Focused coverage: menu renderer / stacked rows, weekly bar prefix, Codex and Claude daily cost history.
- Release packaging checks the app's deep code signature and records build provenance in `Contents/Resources/AgentBarRelease.json`.
- Source reconstruction validates that the patch applies to the exact pinned upstream commit.
- The preset supports `bash scripts/apply-preset.sh --dry-run`; this makes no settings changes and performs no provider or credential reads.

For future Swift changes, run upstream focused tests with its test environment and `make check`; avoid live provider probes or Keychain access during automated tests. Do not mistake the historical test run above for a new test run on later changes.

## Release

Tag the source revision, attach the ZIP and SHA256SUMS to a GitHub release, and include the compatibility / signing notes. Never commit personal defaults, account configuration, cookies, tokens, usage snapshots, or runtime logs. The preview image uses synthetic values.

### 0.1.1 validation

Run from `.build/upstream` with an existing Python that supplies `os.waitid`/`WNOWAIT` first on PATH. This machine used `/opt/anaconda3/bin/python3` (3.13.5); the Xcode Python 3.9 runner does not provide the required process-containment API.

```bash
PATH="/opt/anaconda3/bin:$PATH" ./Scripts/test_fast.sh --filter 'ClaudeWebRecoveryPolicyTests|ClaudeWebAutomaticRecoveryTests|ClaudeWebBackgroundRecoveryTests|ClaudeWebBrowserFallbackTests|ClaudeWebRecoveryMenuTests|ClaudeWebRefreshResilienceTests'
PATH="/opt/anaconda3/bin:$PATH" make check
```

The source patch is also applied to a fresh extraction of the SHA-256-verified upstream archive, then every modified file is compared byte-for-byte with the build source. Patch files disable Git whitespace diagnostics for unified-diff context lines; Swift source is still checked by SwiftFormat and SwiftLint.

A controlled reboot reproduction is separate from these stubbed tests. The release improves retry behavior and error classification; it does not grant macOS permissions or claim to repair TCC. An ad-hoc signed update may need one-time permission re-authorization.

Swift 6.3.3 needed an explicit typed subexpression in the existing throughput sparkline test. Its numeric fixture values and assertions are unchanged.

Verified on 2026-10-22: 50 tests in 7 focused recovery/throughput suites passed; `make check` passed with zero SwiftLint violations across 3,019 Swift files. These tests use synthetic stores and stubbed HTTP responses, not live account probes.

An additional 50 tests in BrowserDetectionTests and OpenAIDashboardBrowserCookieImporterTests passed, for 100 passing focused tests across 9 suites.
