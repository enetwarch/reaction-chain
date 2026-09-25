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

  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'confirmationEnabled': confirmationEnabled,
    'vibrationEnabled': vibrationEnabled,
  };

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      confirmationEnabled: json['confirmationEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
    );
  }
}
