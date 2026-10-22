# Changelog

## 0.1.1 — 2026-10-22

- Retry failed Claude web connections after 15, 30, 60, and 120 seconds, then every 5 minutes. Rate limits and Cloudflare challenges wait at least 5 minutes.
- Distinguish browser permission denial, absent or expired login, and unreadable cookie stores. Provide English and Korean messages.
- Detect Safari directory access denial even when cookie-store discovery reports the store as missing.
- Keep a new permission failure visible instead of replacing it with an older cached-session login error.
- Cancel retries after success, provider disablement, or a Claude configuration change. Reuse the existing account-aware refresh coordinator and background prompt restrictions.
- Preserve the aligned menu bar layout and existing daily history changes.

This release remains ad-hoc signed and is not notarized. An updated app may need one-time macOS permission re-authorization. Automatic retries cannot grant permissions or complete a login. The original reboot issue has not been reproduced in a controlled reboot test; this release improves recovery and diagnosis rather than claiming to repair macOS TCC itself.
