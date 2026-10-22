# AgentBar

A macOS menu bar app showing **Codex and Claude Code weekly remaining quota** in two aligned rows.

[**Project Page ↗**](https://heeyoung37-37.github.io/agentbar/) · [**Download v0.1.1 ↓**](https://github.com/heeyoung37-37/agentbar/releases/download/v0.1.1/AgentBar-0.1.1-macos-arm64.zip) · [Release notes / SHA256SUMS](https://github.com/heeyoung37-37/agentbar/releases/tag/v0.1.1)

[![AgentBar menu bar example: Codex 62%, Claude 97% remaining. Source-based view with fictional values.](https://heeyoung37-37.github.io/agentbar/assets/readme-hero.png?v=2)](https://heeyoung37-37.github.io/agentbar/)

## Features

- Fixed columns and monospaced digits keep provider names, percentages, and bars aligned from `100%` to single-digit values.
- Monochrome weekly bars omit the `W` label. The detail view retains existing provider colors.
- Claude web connections retry automatically after 15, 30, 60, and 120 seconds, then every 5 minutes. Background retries do not open authentication prompts.
- Permission failures, missing/expired logins, and unreadable cookie stores have separate messages (English and Korean).
- Claude cost charts retain the last 30 daily slots. Unused days become zero only after a full scan; unknown records remain distinct.

The [Project Page](https://heeyoung37-37.github.io/agentbar/) includes interactive examples. All example values are fictional. The original [menu bar preview](docs/menubar.png) also uses synthetic data.

## Install

**Apple Silicon (M1 or later) · macOS 14+**

1. Download and extract the ZIP, then move `AgentBar.app` to **Applications**.
2. Quit any running CodexBar or AgentBar instance.
3. Run the included `Apply AgentBar Preset.command`. It enables both providers and **overwrites existing display preferences**.
4. Open AgentBar and connect **your own Codex and Claude accounts**. No login information is included.

> **Ad-hoc signed; not notarized by Apple.** Verify the source and release checksum. If macOS blocks the app, review the restriction in **System Settings → Privacy & Security**.

AgentBar shares settings and app identifiers with CodexBar; do not run both at once. Browser sessions require your own login and macOS permissions. Retrying cannot grant permissions or sign in for you. Because this is an ad-hoc signed update, macOS may require you to re-authorize the updated app once. Automatic updates are disabled; install updates manually from [Releases](https://github.com/heeyoung37-37/agentbar/releases).

## Source and build

An unofficial modification of [CodexBar v0.76.0](https://github.com/steipete/CodexBar/tree/v0.76.0), distributed as a patch against a pinned upstream commit. Internal binaries and some settings retain the CodexBar name. Website files are maintained separately on [`gh-pages`](https://github.com/heeyoung37-37/agentbar/tree/gh-pages).

```bash
bash scripts/prepare-source.sh  # Download, verify SHA-256, and apply the patch
bash scripts/build.sh          # Requires Xcode, Swift 6.2+, and Python 3
```

[Build guide](DEVELOPMENT.md) · [Patch](patches/agentbar.patch) · [Third-party notices](THIRD_PARTY_NOTICES.md)

Original: [Peter Steinberger / CodexBar](https://github.com/steipete/CodexBar) · [MIT License](LICENSE)  
AgentBar modifications: [heeyoung37-37](https://github.com/heeyoung37-37) · MIT  
Not an official OpenAI or Anthropic product.
