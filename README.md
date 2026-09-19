<!--
  This is your project's front page. Replace every placeholder below.
  It is the first thing your instructor and any future employer will read, and
  the live link in it is how your project gets opened for grading.

  New here? Read START-HERE.md first. Delete this comment when you are done.
-->

# Reaction Chain

> For board game enthusiasts looking for a better [Chain Reaction](https://play.google.com/store/apps/details?id=com.BuddyMattEnt.ChainReaction&hl=en) experience. 

- **Live demo:** [enetwarch.github.io/reaction-chain/](https://enetwarch.github.io/reaction-chain/)
- **Demo video:** `docs/demo.mp4` (link it here once it exists)
- **Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University
- **Author:** Enetwarch (Hugo Molina)

## Screenshots

```markdown
| Home | Detail | Add |
| --- | --- | --- |
| ![Home](docs/assets/screen-home.png) | ![Detail](docs/assets/screen-detail.png) | ![Add](docs/assets/screen-add.png) |
```

## What it does

Three to five bullets. What can a user actually do?

- The user can create a custom lobby, with a minimum of 2 and maximum of 4 players.
- The user can play a full local match of Chain Reaction, placing orbs and triggering chain reactions until only one player remains.
- The user can adjust game settings such as sound, music, vibration, and move confirmation.
- The user can resign from an ongoing match if they no longer wish to continue.
- The user can undo a move or pause the game mid-match.

## Built with

| | |
| --- | --- |
| Framework | Flutter (Dart) |
| State | `setState`, `ListenableBuilder` |
| Storage | `shared_preferences` |
| Other packages | `just_audio` for SFX |

## Running it yourself

```bash
flutter pub get
flutter run -d web-server --web-port 8080
```

Then open http://localhost:8080. Requires Flutter version `3.41.9`.

## Privacy and secrets

- The app does not store any personal or sensitive data. All data lives in the local storage with the use of `shared_preferences`.
- There are no `.env` files involved in this project as no API or online services are used.

## Project documentation

| Document | |
| --- | --- |
| [Proposal](docs/01-proposal.md) | the problem, the users, the scope |
| [Mockup and wireframes](docs/02-mockup.md) | what it looks like, and the screen flow |
| [Design system](docs/03-design-system.md) | colors, type, spacing, components |
| [Weekly reports](docs/04-weekly-reports.md) | what happened each week |
| [Demo video](docs/05-demo-video.md) | the recording and what it shows |
| [Security and privacy](docs/06-security-and-privacy.md) | the checklist, filled in |

## Status and what is next

The home page and local lobby page are basically complete, with some refinements for later. The game page has its functionality down, but lacking in animations, which is the next focus for development.

## Credits

- Packages: see [`pubspec.yaml`](./pubspec.yaml)
- Assets, icons, 3D models, sounds: (none so far)
- People who helped: (none so far)

## AI use

I use AI tools to help me self-study Flutter classes and packages I will use in this project. I basically use it as a glorified search engine and personalized teacher.

## Licence

MIT, see [LICENSE](LICENSE).
