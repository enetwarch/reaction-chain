import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  bool soundEnabled;
  bool musicEnabled;
  bool confirmationEnabled;
  bool vibrationEnabled;

  Settings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.confirmationEnabled = true,
    this.vibrationEnabled = true,
  });

  static const _soundKey = 'settings.soundEnabled';
  static const _musicKey = 'settings.musicEnabled';
  static const _confirmationKey = 'settings.confirmationEnabled';
  static const _vibrationKey = 'settings.vibrationEnabled';

  static Future<Settings> load() async {
    final preferences = await SharedPreferences.getInstance();
    return Settings(
      soundEnabled: preferences.getBool(_soundKey) ?? true,
      musicEnabled: preferences.getBool(_musicKey) ?? true,
      confirmationEnabled: preferences.getBool(_confirmationKey) ?? true,
      vibrationEnabled: preferences.getBool(_vibrationKey) ?? true,
    );
  }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundKey, soundEnabled);
    await preferences.setBool(_musicKey, musicEnabled);
    await preferences.setBool(_confirmationKey, confirmationEnabled);
    await preferences.setBool(_vibrationKey, vibrationEnabled);
  }
}
