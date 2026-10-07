import 'dart:async';

import 'package:flutter/material.dart';
import '../data/board.dart';
import '../data/settings.dart';

class HighlightController extends ChangeNotifier {
  final Settings settings;
  final Color Function(BuildContext) colorOfBlink;
  final Color Function(BuildContext) colorOfArm;
  final Color Function(BuildContext) colorOfExploding;
  final VoidCallback? onDisarm;

  HighlightController({
    required this.settings,
    required this.colorOfBlink,
    required this.colorOfArm,
    required this.colorOfExploding,
    this.onDisarm,
  });

  Map<Coordinates, CellHighlight> _highlights = const {};
  Map<Coordinates, CellHighlight> get highlights => _highlights;

  bool get hasArmed => _highlights.values.any(
    (highlight) => highlight.mode == CellHighlightMode.armed,
  );
  bool get hasBlinking => _highlights.values.any(
    (highlight) => highlight.mode == CellHighlightMode.blink,
  );

  static const _armDuration = Duration(seconds: 5);
  Timer? _armTimer;

  @override
  void dispose() {
    _armTimer?.cancel();
    super.dispose();
  }

  void blink(List<Coordinates> coordinates) {
    if (!settings.highlightEnabled) return clear();
    _cancelArmTimer();
    _highlights = {
      for (final coords in coordinates)
        coords: CellHighlight.blink(colorOf: colorOfBlink),
    };
    notifyListeners();
  }

  void arm(Coordinates coordinates) {
    _cancelArmTimer();
    _armTimer?.cancel();
    _highlights = Map.unmodifiable({
      coordinates: CellHighlight.armed(colorOf: colorOfArm),
    });
    notifyListeners();
    _armTimer = Timer(_armDuration, disarm);
  }

  void disarm() {
    if (_armTimer == null) return;
    _cancelArmTimer();
    notifyListeners();
    onDisarm?.call();
  }

  bool isArmed(Coordinates coordinates) =>
      _highlights[coordinates]?.mode == CellHighlightMode.armed;

  void exploding(List<Coordinates> coordinates) {
    _cancelArmTimer();
    _highlights = Map.unmodifiable({
      for (final coords in coordinates)
        coords: CellHighlight.exploding(colorOf: colorOfExploding),
    });
    notifyListeners();
  }

  void clear() {
    _cancelArmTimer();
    _highlights = const {};
    notifyListeners();
  }

  void _cancelArmTimer() {
    _armTimer?.cancel();
    _armTimer = null;
  }
}
