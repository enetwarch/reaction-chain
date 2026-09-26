import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reaction_chain/data/game_state.dart';
import 'package:reaction_chain/data/player.dart';
import 'package:reaction_chain/data/settings.dart';

class LocalStorage {
  final SharedPreferences _preferences;

  LocalStorage(this._preferences);

  // Storage Keys
  static const _settingsKey = 'app_settings';
  static const _playersKey = 'saved_players';
  static const _gameStateKey = 'active_game';

  Settings loadSettings() {
    final raw = _preferences.getString(_settingsKey);
    if (raw == null) return Settings();
    try {
      return Settings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return Settings();
    }
  }

  Future<bool> saveSettings(Settings settings) {
    return _preferences.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  List<Player> loadPlayers() {
    final rawList = _preferences.getStringList(_playersKey);
    if (rawList == null) return Player.defaultPlayers;
    try {
      return rawList
          .map(
            (item) => Player.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return Player.defaultPlayers;
    }
  }

  Future<bool> savePlayers(List<Player> players) {
    final jsonList = players
        .map((player) => jsonEncode(player.toJson()))
        .toList();
    return _preferences.setStringList(_playersKey, jsonList);
  }

  GameState? loadGameState() {
    final raw = _preferences.getString(_gameStateKey);
    if (raw == null) return null;
    try {
      return GameState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveGameState(GameState gameState) {
    return _preferences.setString(
      _gameStateKey,
      jsonEncode(gameState.toJson()),
    );
  }

  Future<bool> clearGameState() {
    return _preferences.remove(_gameStateKey);
  }

  Future<bool> clearAll() => _preferences.clear();
}
