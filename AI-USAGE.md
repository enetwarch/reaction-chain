# AI usage

<!--
This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.
-->

## 1. How I used AI

<!--
At least six entries. One per real use. Every entry needs a commit link.
-->

### 2026-08-15 - game screen functionality

- **Tool:** Claude (web chat)
- **What I asked for:** To make the game screen functional, without animations, transitions, or anything fancy.
- **What it gave back:** It gave back a basically working game of Chain Reaction. The game screen still needs animations, dialogs, undo, redo, pause, and a bunch of other refinements, but this specific commit does make the game screen functional.
- **What I kept, what I changed, and why:** The board widget basically listens to the game controller's board data. I changed a bit of design token and spacing values to match my finalized mockup, this seems to be what the AI always seems to get wrong despite knowing my AppTheme and mockup. I kept everything else because the game works properly just like in Chain Reaction.
- **Commit:** [`7a9713e`](https://github.com/enetwarch/reaction-chain/commit/7a9713ea49a7cf02e8e679852722fa9e8649feb5#diff-364a7b23d8ef4de76795096ddd9095258ea4509635a65c4911020aea7322e738)

### 2026-09-20 - local lobby screen revision

- **Tool:** Claude (web chat)
- **What I asked for:** I asked for a revision on the Local Lobby Page to match my final mockup.
- **What it gave back:** It gave back a mostly similar output to what I had in Figma. However, it used wrong design tokens and spacing on certain areas despite knowing my `AppTheme` and `AppDimensions` components.
- **What I kept, what I changed, and why:** I changed the drag icon to be a `drag_indicator_rounded`. For the `PlayerCardDailog` component in the same page, I simply changed the wrong theme colors and adjusted the spacing to match the Figma mockup. I kept everything else. Remember, I already have an output I made myself from a month ago, and Claude just modified it to match the finalized mockup, so I still had some part in making the `LocalLobbyScreen`.
- **Commit:** [`239516b`](https://github.com/enetwarch/reaction-chain/commit/239516b3ceb213ad7eb74a0ea87aba7fd303b3a3)

### 2026-09-21 - icon button variants

- **Tool:** Claude (web chat)
- **What I asked for:** A shared, modular icon button component to replace the ad-hoc fixed-size buttons I had scattered across screens, since that was flagged as a blocker in my week 1 report. I already had an `AppIconButton` established and written by myself, I just need help with the variants, which it can quickly help code up for me.
- **What it gave back:** An `AppArmedIconButton` (tap-to-arm, tap-again-to-confirm, for destructive actions like deleting a player) built on top of it using `TweenAnimationBuilder` for the color swap. I also requested for an `AppToggleIconButton` afterwards to help with the construction of `SettingsDialog`. It is very similar to `AppArmedIconButton`, but it has an infinite arm duration. 
- **What I kept, what I changed, and why:** Kept the component structure as given, since it was based from the base `AppIconButton` component I wrote. This became the foundation every dialog and screen built afterward reused, instead of writing one-off buttons.
- **Commit:** [`6851f14`](https://github.com/enetwarch/reaction-chain/commit/6851f14), [`204eca5`](https://github.com/enetwarch/reaction-chain/commit/204eca5), and [`cb55789`](https://github.com/enetwarch/reaction-chain/commit/cb55789f9e9f2acfd968adae148935fbb0446ecc)

### 2026-09-23 to 24 - persistence via context provider pattern

- **Tool:** Claude (web chat)
- **What I asked for:** To extend the `LocalStorageProvider` context-provider pattern I'd already built for the Local Lobby Screen into the Game Screen, so game state (board, players, turn) could be saved and resumed the same way.
- **What it gave back:** A `LocalStorage`-aware `GameController` that persists after every completed move and clears the save on a win, plus a `GameScreen` that can construct from either a fresh player list or a loaded `GameState`, following the same `didChangeDependencies`/`_isInitialized` init pattern I was already using in `LocalLobbyScreen`.
- **What I kept, what I changed, and why:** The original approach put the "did this move count" check inside `GameScreen` itself; I pushed back since it didn't match my own pattern of keeping persistence logic in controllers, and had it moved into `GameController` so the screen doesn't need to know about persistence at all.
- **Commit:** [`b9b25be`](https://github.com/enetwarch/reaction-chain/commit/b9b25be), [`4aed8bb`](https://github.com/enetwarch/reaction-chain/commit/4aed8bb), [`83176bc`](https://github.com/enetwarch/reaction-chain/commit/83176bc)

### 2026-09-27 - week 2 documentation

- **Tool:** Claude (web chat)
- **What I asked for:** Help writing up the week 2 Project Increment Report, Reflection Journal, and Security Checklist. This entry is specifically about week 2, my week 1 documentation was written entirely by me.
- **What it gave back:** Drafts structured from my own commit log and my own account of what happened and what blocked me, which I then corrected (e.g. adding that "polishing" took the whole week instead of leaving room for animations, as I'd originally planned).
- **What I kept, what I changed, and why:** I switched my process this week: instead of writing the documentation myself first, I gave my raw progress and ideas and had Claude articulate them into the report format, to save time after realizing in week 1 that documentation was taking longer than the coding itself. Even with the assistance of AI in the documentation, it still takes a massive chunk of time to accomplish, proofread, and correct the articulation of text.
- **Commit:** [`d8e33ba`](https://github.com/HAU-6ADET/student-6adet-2134-enetwarch/commit/d8e33ba58ffe5392e9587c52d81635c2170dc91a), [`d13d9b6`](https://github.com/HAU-6ADET/student-6adet-2134-enetwarch/commit/d13d9b6ed51263e775bf2b14684a920206058739), and [`d780bbe`](https://github.com/HAU-6ADET/student-6adet-2134-enetwarch/commit/d780bbea6633a85c90094f64b983fbd29d678d1d)

<!--
### YYYY-MM-DD - short title

- **Tool:** 
- **What I asked for:** 
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 
-->

## 2. Where the AI got it wrong

<!--
Three cases. Be specific. If you write that the AI was never wrong, this section
scores zero.
-->

### Case 1 - incomplete ellipsis fix

- **What it gave me:** A fix for player name text getting cut off instead of showing an ellipsis, described as needing the `Text` widget itself wrapped in `Expanded` — but the actual code sample only wrapped the outer row, not the `Text`.
- **What was wrong with it:** The explanation and the code didn't match. Applying the code as given still cut the text off with no ellipsis, since the `Text` still had unbounded width to render into.
- **What I did instead:** The solution was pretty simple and one I wrote back in my midterm reflection journal. I corrected it by wrapping an `Expanded` around the `Text`.
- **Commit:** [`6f60bbb`](https://github.com/enetwarch/reaction-chain/commit/6f60bbb)

### Case 2 - imperceptible highlight animation

- **What it gave me:** A first version of the current-player score card highlight that tinted the background toward the player's color at only partial strength (roughly 20%), reasoning that a full-strength player color as a background would clash with player-colored text/icon on top of it.
- **What was wrong with it:** The tint was so subtle the animation was effectively invisible — I couldn't tell it was animating at all when I tested it.
- **What I did instead:** I did the fix myself by looking through my `AppArmedIconButton` component and replicating it in the player score cards, it took a while from doing it myself but it did work eventually.
- **Commit:** [`d3ab70b`](https://github.com/enetwarch/reaction-chain/commit/d3ab70b)

<!--
### Case # - short title

- **What it gave me:**
- **What was wrong with it:**
- **What I did instead:**
- **Commit:** https://github.com/YOUR-USERNAME/YOUR-REPO/commit/SHA
-->

## 3. Who wrote what

<!--
At least a fifth of this project is code you wrote yourself. Name it, and explain
it in your own words.

> Group projects: give each member their own heading below, and use your GitHub
> handle as the heading. You are graded on your own section.
-->

### Written by me

#### Home Screen

- **File:** [`lib/screens/home_screen.dart`](https://github.com/enetwarch/reaction-chain/blob/main/lib/screens/home_screen.dart)
- **Commit:** [`1a791ef`](https://github.com/enetwarch/reaction-chain/commit/1a791efe1f75369ec333794697fffd4403f4e98c) and [`ba24ab8`](https://github.com/enetwarch/reaction-chain/commit/ba24ab898dbd4bc6c7c2240bdac05fbc1b8c9d44)
- **What it does and why it is built this way:** This is the simplest screen by far. This is the first page the user lands to when they open the app. It has a title at the top, a big play button in the middle, and three buttons at the bottom: info (links to a website with Chain Reaction rules), settings, and source code (links to GitHub repository). I built it this way to keep my minimal and sleek design theme. The play button is placed in the middle to emphasize that it is the main functionality of the app.

#### Confirmation dialog

- **File:** [`lib/widgets/confirmation_dialog.dart`](https://github.com/enetwarch/reaction-chain/blob/main/lib/widgets/confirmation_dialog.dart)
- **Commit:** [`6f60bbb`](https://github.com/enetwarch/reaction-chain/commit/6f60bbb)
- **What it does and why it is built this way:** A reusable dialog with a title, optional icon, description, and close/confirm callbacks, used for the "continue your saved game?" flow on the Home Screen. I wrote most of this myself, following the same `Dialog` → `ConstrainedBox` → `Container` structure as my own `PlayerCardDialog`, since I wanted it to feel consistent with a component I'd already built rather than introduce a new dialog shape. The icon is conditionally included via `if (icon != null)` inside the `Column`'s children so it doesn't reserve space when absent, and popping the dialog is left to the caller rather than handled internally, matching how `onDelete`/`onClose` already work in `PlayerCardDialog`.

<!--
#### ...

- **File:** 
- **Commit:**
- **What it does and why it is built this way:**
-->

### The AI-written part I understand best

#### Local Lobby Page

- **File:** [`lib/screen/home_screen.dart`](https://github.com/enetwarch/reaction-chain/blob/main/lib/screens/local_lobby_screen.dart)
- **Commit:** [`239516b`](https://github.com/enetwarch/reaction-chain/commit/239516b3ceb213ad7eb74a0ea87aba7fd303b3a3)
- **What it does and why I kept it:** This is a revision of the local lobby screen that I had initially made. First of all, the AI added functions and data in the `player_list_controller.dart` and `player.dart` file to help build on the local lobby screen. What changed in the `local_lobby_screen.dart` file was mostly the arguments that needed to be passed to `PlayerCardDialog`, along with a bit of spacing and drag handle icon which I personally coded in for this commit. The majority of the `PlayerCardDialog` changes are from the AI. It changed the dialog size to min-width 240 to max-width 300 instead of just having a fixed 240. The first row would also change depending on if the player. If human, it will use `_NameRow`, if bot, it will use `_LevelRow` (not yet implemented because it is not in MVP). The name row has a text field on the left that can be edited with the edit button on the right (pencil icon). When the user is done editing, they can press enter on their keyboard or click the check button (temporarily replaced edit button). The second row after is the `_ColorEditRow`. On the left, it has a dropdown menu that opens whenever the user clicks it, having the options: red, green, blue, and yellow. On the right is a randomize button, simply changes the current color to a random one.

#### LocalStorageProvider pattern

- **File:** `lib/providers/local_storage_provider.dart`
- **Commit:** [`b9b25be`](https://github.com/enetwarch/reaction-chain/commit/b9b25be9e28e6931a689c3837167d9a1f81c92a8)
- **What it does and why I kept it:** A context-provider pattern that lets any screen or controller reach persistence via `LocalStorageProvider.of(context)` instead of having it threaded through every constructor. I originally sketched this for the Local Lobby Screen myself, then had it extended to the Game Screen and Home Screen. I understand it well because it's the same concept as React's Context API — an ancestor widget makes a value available to any descendant that asks for it via `context`, without prop-drilling it through every layer in between. Flutter's `InheritedWidget` (which this pattern is built on) is doing the same job `React.createContext` + `useContext` does.

<!--
#### ...

- **File:** 
- **Commit:** 
- **What it does and why I kept it:** 
-->
