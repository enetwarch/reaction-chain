class Settings {
  bool soundEnabled;
  bool vibrationEnabled;
  bool highlightEnabled;
  bool confirmationEnabled;

  Settings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.highlightEnabled = true,
    this.confirmationEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'vibrationEnabled': vibrationEnabled,
    'highlightEnabled': highlightEnabled,
    'confirmationEnabled': confirmationEnabled,
  };

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      highlightEnabled: json['highlightEnabled'] as bool? ?? true,
      confirmationEnabled: json['confirmationEnabled'] as bool? ?? true,
    );
  }
}
