# Development

AgentBar is a compact patch distribution of CodexBar, not a separately implemented usage client.

## Build

Use macOS 14+, full Xcode with Swift 6.2+ selected by `xcode-select`, and Python 3. Network access is needed for the pinned source and SwiftPM dependencies.

```bash
bash scripts/prepare-source.sh
bash scripts/build.sh
```

The default build targets the host architecture; `ARCHES="arm64 x86_64" bash scripts/build.sh` requests a universal build. Only the initial arm64 binary has been validated for this release. The output is `dist/AgentBar-0.1.0-macos-<arch>.zip` and `dist/SHA256SUMS`.

`prepare-source.sh` checks the upstream archive SHA-256 and applies `patches/agentbar.patch`. It never touches installed apps or credentials. The complete patched source is in `.build/upstream/`.

`package-release.sh /path/to/CodexBar.app` repackages an already built app. It changes the display name, disables upstream automatic updates, retains the original bundle identifiers for compatibility, and applies an ad-hoc signature. Release v0.1.0 uses the previously validated local build, repackaged through this script; it is not notarized.

## Validation

- Original local build (2026-10-16): 117 focused tests in 6 suites, lint, release packaging and smoke checks passed.
- Focused coverage: menu renderer / stacked rows, weekly bar prefix, Codex and Claude daily cost history.
- Release packaging checks the app's deep code signature and records build provenance in `Contents/Resources/AgentBarRelease.json`.
- Source reconstruction validates that the patch applies to the exact pinned upstream commit.
- The preset supports `bash scripts/apply-preset.sh --dry-run`; this makes no settings changes and performs no provider or credential reads.

For future Swift changes, run upstream focused tests with its test environment and `make check`; avoid live provider probes or Keychain access during automated tests. Do not mistake the historical test run above for a new test run on later changes.

## Release

Tag the source revision, attach the ZIP and SHA256SUMS to a GitHub release, and include the compatibility / signing notes. Never commit personal defaults, account configuration, cookies, tokens, usage snapshots, or runtime logs. The preview image uses synthetic values.
