# Weekly reports

<!--
One entry per week, newest at the top, written **during** that week. Five minutes
each. They are the record of how the project actually went, and they make your
final reflection almost write itself.

Copy this block:

---

## Week N (date to date)

**Done this week**
-

**In progress**
-

**Blocked or stuck on**
-

**Decisions made, and why**
-

**Hours spent, roughly:**

**Next week I will:**
-

---
-->

## Week 1 (September 14–20, 2026)

**Done this week**
- Built the basic Home, Local Lobby, and Game screens based on the finalized mockups.
- Created `AppTheme` and `AppDimensions` for consistent styling and spacing.
- Implemented `PlayerCardDialog`, `Board`, and `GameController`.
- Organized the project using separate `controllers/`, `data/`, `screens/`, `theme/`, and `widgets/` directories.
- Integrated the required project template and updated the README.

**In progress**
- Game screen animations and remaining dialogs.
- Reusable icon button component and responsive sizing.
- Lobby validation and additional game controls.

**Blocked or stuck on**
- Integrating the project template into an existing repository.
- Updating screens to match finalized mockups after initially coding from wireframes.
- Fixed button sizing caused overflow on smaller screens.

**Decisions made, and why**
- Finalized mockups before continuing implementation to reduce unnecessary refactoring.
- Separated data classes, controllers, screens, and reusable widgets to keep the code organized.
- Prioritized local multiplayer features to work toward the MVP.

**Hours spent, roughly:** 5 (+20 including the previous weeks).

**Next week I will:**
- Implement persistence for player lists and game state.
- Build the icon button component and missing dialogs.
- Improve responsive layouts and begin polishing game animations.

---

## Week 2 (September 21–27, 2026)

**Done this week**
- Added `LocalStorageProvider` and persistence for player lists and game state.
- Created reusable icon button variants, including armed-confirm and toggle buttons.
- Built the Settings dialog, player-add speed dial, and reusable `ConfirmationDialog`.
- Extracted the game board into `BoardWidget`.
- Fixed layout, spacing, player-name overflow, and player deletion bugs.
- Added a current-player score highlight animation and automatic scrolling.

**In progress**
- Winner and resignation dialogs.
- Minimum player-count validation before starting a game.
- Undo, redo, and pause functionality.
- Orb animations and remaining UI polish.

**Blocked or stuck on**
- Getting text ellipsis to work correctly within constrained layouts.
- Managing saved-game state when a user declines to resume.
- Supporting mouse dragging and horizontal scrolling in the web build.

**Decisions made, and why**
- Used a context-provider pattern for persistence to avoid passing storage through multiple constructors.
- Created reusable icon button variants to support consistent interactions and prevent accidental destructive actions.
- Added custom scrolling behavior to improve desktop and web usability.
- Enforced a 10-character player-name limit to prevent layout overflow.

**Hours spent, roughly:** 20.

**Next week I will:**
- Continue implementing missing game dialogs and validation.
- Add orb animations and improve the gameplay experience.
- Implement or reassess the remaining game controls.
