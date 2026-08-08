// lib/theme/player_colors.dart
import 'package:flutter/material.dart';

// Separate extension for player colors because there is no semantic
// name for them in `ThemeData.colorScheme`.
class PlayerColors extends ThemeExtension<PlayerColors> {
  final Color red;
  final Color green;
  final Color blue;
  final Color yellow;

  const PlayerColors({
    required this.red,
    required this.green,
    required this.blue,
    required this.yellow,
  });

  static const dark = PlayerColors(
    red: Color(0xFFF43E3E),
    green: Color(0xFF3EF43E),
    blue: Color(0xFF3E8FF4),
    yellow: Color(0xFFF4F43E),
  );

  @override
  PlayerColors copyWith({
    Color? red,
    Color? green,
    Color? blue,
    Color? yellow,
  }) {
    return PlayerColors(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      yellow: yellow ?? this.yellow,
    );
  }

  @override
  PlayerColors lerp(ThemeExtension<PlayerColors>? other, double t) {
    if (other is! PlayerColors) return this;
    return PlayerColors(
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
    );
  }
}
