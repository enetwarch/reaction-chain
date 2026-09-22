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

- **Tool:** Claude Code
- **What I asked for:** To make the game screen functional, without animations, transitions, or anything fancy.
- **What it gave back:** It gave back a basically working game of Chain Reaction. The game screen still needs animations, dialogs, undo, redo, pause, and a bunch of other refinements, but this specific commit does make the game screen functional.
- **What I kept, what I changed, and why:** The board widget basically listens to the game controller's board data. I changed a bit of design token and spacing values to match my finalized mockup, this seems to be what the AI always seems to get wrong despite knowing my AppTheme and mockup. I kept everything else because the game works properly just like in Chain Reaction.
- **Commit:** [`7a9713ea49a7cf02e8e679852722fa9e8649feb5`](https://github.com/enetwarch/reaction-chain/commit/7a9713ea49a7cf02e8e679852722fa9e8649feb5#diff-364a7b23d8ef4de76795096ddd9095258ea4509635a65c4911020aea7322e738)

### 2026-09-20 - local lobby screen revision

- **Tool:** Claude Code
- **What I asked for:** I asked for a revision on the Local Lobby Page to match my final mockup.
- **What it gave back:** It gave back a mostly similar output to what I had in Figma. However, it used wrong design tokens and spacing on certain areas despite knowing my `AppTheme` and `AppDimensions` components.
- **What I kept, what I changed, and why:** I changed the drag icon to be a `drag_indicator_rounded`. For the `PlayerCardDailog` component in the same page, I simply changed the wrong theme colors and adjusted the spacing to match the Figma mockup. I kept everything else. Remember, I already have an output I made myself from a month ago, and Claude just modified it to match the finalized mockup, so I still had some part in making the `LocalLobbyScreen`.
- **Commit:** [`239516b3ceb213ad7eb74a0ea87aba7fd303b3a3`](https://github.com/enetwarch/reaction-chain/commit/239516b3ceb213ad7eb74a0ea87aba7fd303b3a3)

### YYYY-MM-DD - short title

- **Tool:** 
- **What I asked for:** 
- **What it gave back:** 
- **What I kept, what I changed, and why:** 
- **Commit:** 

## 2. Where the AI got it wrong

<!--
Three cases. Be specific. If you write that the AI was never wrong, this section
scores zero.
-->

### Case 1 - short title

- **What it gave me:**
- **What was wrong with it:**
- **What I did instead:**
- **Commit:** https://github.com/YOUR-USERNAME/YOUR-REPO/commit/SHA

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
- **Commit:** [`1a791efe1f75369ec333794697fffd4403f4e98c`](https://github.com/enetwarch/reaction-chain/commit/1a791efe1f75369ec333794697fffd4403f4e98c) and [`ba24ab898dbd4bc6c7c2240bdac05fbc1b8c9d44`](https://github.com/enetwarch/reaction-chain/commit/ba24ab898dbd4bc6c7c2240bdac05fbc1b8c9d44)
- **What it does and why it is built this way:** This is the simplest screen by far. This is the first page the user lands to when they open the app. It has a title at the top, a big play button in the middle, and three buttons at the bottom: info (links to a website with Chain Reaction rules), settings, and source code (links to GitHub repository). I built it this way to keep my minimal and sleek design theme. The play button is placed in the middle to emphasize that it is the main functionality of the app.

#### ...

- **File:** 
- **Commit:**
- **What it does and why it is built this way:**

### The AI-written part I understand best

#### Local Lobby Page

- **File:** [`lib/screen/home_screen.dart`](https://github.com/enetwarch/reaction-chain/blob/main/lib/screens/local_lobby_screen.dart)
- **Commit:** [`239516b3ceb213ad7eb74a0ea87aba7fd303b3a3`](https://github.com/enetwarch/reaction-chain/commit/239516b3ceb213ad7eb74a0ea87aba7fd303b3a3)
- **What it does and why I kept it:** This is a revision of the local lobby screen that I had initially made. First of all, the AI added functions and data in the `player_list_controller.dart` and `player.dart` file to help build on the local lobby screen. What changed in the `local_lobby_screen.dart` file was mostly the arguments that needed to be passed to `PlayerCardDialog`, along with a bit of spacing and drag handle icon which I personally coded in for this commit. The majority of the `PlayerCardDialog` changes are from the AI. It changed the dialog size to min-width 240 to max-width 300 instead of just having a fixed 240. The first row would also change depending on if the player. If human, it will use `_NameRow`, if bot, it will use `_LevelRow` (not yet implemented because it is not in MVP). The name row has a text field on the left that can be edited with the edit button on the right (pencil icon). When the user is done editing, they can press enter on their keyboard or click the check button (temporarily replaced edit button). The second row after is the `_ColorEditRow`. On the left, it has a dropdown menu that opens whenever the user clicks it, having the options: red, green, blue, and yellow. On the right is a randomize button, simply changes the current color to a random one.

#### ...

- **File:** 
- **Commit:** 
- **What it does and why I kept it:** 
