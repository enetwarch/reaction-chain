import 'package:flutter/material.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/services/local_storage.dart';

// Needs to be passed to a `ListenableBuilder()` to work properly.
class PlayerListController extends ChangeNotifier {
  final List<Player> _players;
  final LocalStorage localStorage;

  PlayerListController({
    required this.localStorage,
    List<Player>? initialPlayers,
  }) : _players = initialPlayers ?? localStorage.loadPlayers();

  List<Player> get players => List.unmodifiable(_players);

  bool get isFull => _players.length >= 4;
  bool get isMinimum => _players.length <= 1;

  int get playerCount => _players.length;
  int get humanPlayerCount => _players.whereType<HumanPlayer>().length;
  int get botPlayerCount => _players.whereType<BotPlayer>().length;

  PlayerColor? get availableColor => PlayerColor.values
      .where((color) => !_players.any((player) => player.color == color))
      .firstOrNull;

  void addPlayer(PlayerType type) {
    if (isFull) return;

    switch (type) {
      case PlayerType.human:
        _players.add(
          HumanPlayer(
            color: availableColor!,
            name: 'Player ${humanPlayerCount + 1}',
          ),
        );
      case PlayerType.bot:
        _players.add(
          BotPlayer(
            color: availableColor!,
            level: 1,
          ), // This default level could be modifiable in the future.
        );
    }

    _saveAndNotify();
  }

  void reorderPlayer(int oldIndex, int newIndex) {
    // To offset the old rendered player element.
    if (newIndex > oldIndex) newIndex -= 1;

    final player = _players.removeAt(oldIndex);
    _players.insert(newIndex, player);

    _saveAndNotify();
  }

  void changePlayerColor(int index, PlayerColor newColor) {
    if (_players.length <= index) return;
    Player selectedPlayer = _players[index];
    PlayerColor oldColor = selectedPlayer.color;

    if (oldColor == newColor) return;
    for (final player in _players) {
      if ((player == selectedPlayer) || (player.color != newColor)) continue;
      player.color = oldColor;
      break;
    }
    selectedPlayer.color = newColor;

    _saveAndNotify();
  }

  // Only for HumanPlayer players.
  void changePlayerName(int index, String newName) {
    Player selectedPlayer = _players[index];

    if (selectedPlayer case HumanPlayer humanPlayer) {
      humanPlayer.name = newName;
    }

    _saveAndNotify();
  }

  void removePlayer(int index) {
    if (isMinimum) return;
    _players.removeAt(index);

    _saveAndNotify();
  }

  void _saveAndNotify() {
    localStorage.savePlayers(_players);
    notifyListeners();
  }
}
