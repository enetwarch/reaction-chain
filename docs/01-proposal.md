# Proposal

<!--
Paste in the proposal you submitted, and replace it with the final version when
the project is done. You do not need to keep it in sync week to week: nobody
reads this folder until you hand the project in.

Keep these headings so a reader can scan it:
-->

## The problem, in one sentence

Reaction Chain aims to provide a more customizable and engaging version of the classic Chain Reaction board game, with local multiplayer gameplay and a clean, modern interface.

## Who it is for

Board game enthusiasts and casual gamers who want a simple, turn-based multiplayer game that can be played locally with friends.

## Core 

- **Local multiplayer:** Start a local game with 2–4 players.
- **Player customization:** Edit player names and colors, and reorder players before starting a game.
- **Chain Reaction gameplay:** Place orbs on cells, trigger chain reactions when cells reach their critical mass, and continue until one player remains.
- **Settings:** Configure sound effects, music, vibration, and move confirmation.
- **Game presentation:** Provide visual feedback through cell highlighting and animations.
- **Local persistence:** Save relevant settings, player configuration, and game state so the experience can be resumed.

## Out of scope, and why

- **Online multiplayer:** Originally planned as an optional stretch goal, but excluded to keep the project focused on delivering a functional local multiplayer experience within the semester.
- **Bots:** Originally considered as an optional feature, but not implemented because the core local multiplayer experience took priority.
- **Undo, pause, and resign:** These remain works in progress and are not considered completed features.
- **Advanced animations:** The core game logic works, but further animation polish remains a future improvement.

## Data the app remembers, and where it is saved

The app uses `shared_preferences` for local persistence.

- **Player configuration:** Stores relevant local lobby configuration, including player information such as names and colors.
- **Game state:** Stores the current game state so an ongoing game can be restored.
- **Settings:** Stores user preferences, including sound, music, vibration, move confirmation, and cell highlighting.

## Risks

- **Chain reaction logic:** Explosion cascades must correctly process neighboring cells, transfer ownership, and determine when a player wins.
- **Animation and state synchronization:** The UI must display intermediate explosion waves without causing inconsistent game states.
- **Persistence:** Saved settings and game state must be restored correctly without coupling storage logic too tightly to the UI.
- **Time constraints:** Online multiplayer, bots, and advanced animation polish could exceed the available development time, so the project prioritizes the core local multiplayer experience.

## Changes since the last version

<!--
_(A few dated lines saying what changed and why. Worth writing even if you only
do it two or three times: it is the part that shows judgement.)_
-->

- **Initial proposal:** Planned local and online multiplayer, optional bots, configurable settings, and persistent player and game data.
- **During development:** Prioritized local multiplayer and the core Chain Reaction mechanics; online multiplayer and bots were left out of scope.
- **During refinement:** Separated game logic from screen presentation and processed chain reactions in individual waves to support visible animations.
- **Later development:** Added local persistence, configurable settings, cell highlighting, and tap-to-confirm behavior.
- **Current status:** The core local game is functional. Undo, pause, resign, and further animation polish remain future improvements.
