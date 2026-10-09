# Security and privacy

This repository is public. This document records the project's security and
privacy status as of the date below.

**Last checked:** 2026-10-09

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Player names, colors, and player-list configuration | On the device via `shared_preferences` | Anyone with access to the device or its app data |
| Current game state and saved game | On the device via `shared_preferences` | Anyone with access to the device or its app data |
| App settings, such as sound, music, and vibration preferences | On the device via `shared_preferences` | Anyone with access to the device or its app data |

Reaction Chain does not use an online backend or transmit this data to a
remote service. Local storage should not be treated as encrypted or protected
against someone with access to the device.

## Secrets

- **Values my app needs at run time:** None. The app does not require API keys,
  tokens, passwords, or other private configuration.
- **Where they live locally:** Not applicable. No `.env` file or other private
  runtime configuration is needed.
- **Where the deploy workflow gets them:** No secrets are required by the
  active deployment workflow. The commented-out Supabase references are
  unused template scaffolding.
- **Anything my deployed web build carries that a visitor could read, and why
  that is acceptable:** No API keys or private credentials are intentionally
  embedded in the web build. The deployed app contains its compiled Flutter
  web assets, and the app does not connect to an online service.

## What protects the data on the service side

Nothing leaves the device for remote storage. The app has no backend,
Firestore, Supabase, or other database service, so server-side security rules
and row-level security policies do not apply.

## Checklist

- [x] `.env` (or `env.json`) is not needed because the app has no private runtime configuration. Confirm that `.env` is ignored if one is introduced later.
- [x] Git history was reviewed for passwords, secrets, API keys, and tokens; no real credentials were found.
- [x] No service account file, keystore, or `service_role` key is used by the project.
- [x] No backend security rules or RLS policies are needed because no remote database is used.
- [x] Default sample player names are generic placeholders, not real personal data.
- [x] No student number, personal email, phone number, or home address was found in the reviewed repository and commit messages.
- [x] No course or university credentials were found in the reviewed repository.
- [x] This is a solo project and does not collect classmates' personal data.

## Known issue

The GitHub Actions workflow uses third-party actions pinned to version tags
rather than immutable commit SHAs. This remains a known supply-chain security
improvement. The workflow currently does not use active secrets, but pinning
actions to verified commit SHAs would provide stronger protection against
unexpected changes to upstream actions.

No credentials were found that required revocation or rotation during the
security review.
