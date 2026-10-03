import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reaction_chain/data/board.dart';
import 'package:reaction_chain/data/settings.dart';

class HighlightController extends ChangeNotifier {
  final Settings settings;
  final VoidCallback? onDisarm;

  HighlightController({required this.settings, this.onDisarm});

  Map<Coordinates, CellHighlight> _highlights = const {};
  Map<Coordinates, CellHighlight> get highlights => _highlights;

  static const _armDuration = Duration(seconds: 5);
  Timer? _armTimer;

  @override
  void dispose() {
    _armTimer?.cancel();
    super.dispose();
  }

  void blink(
    List<Coordinates> coordinates, {
    required Color Function(BuildContext) colorOf,
  }) {
    _cancelArmTimer();
    _highlights = {
      for (final coords in coordinates)
        coords: CellHighlight.blink(colorOf: colorOf),
    };
    notifyListeners();
  }

  void arm(
    Coordinates coordinates, {
    required Color Function(BuildContext) colorOf,
  }) {
    _cancelArmTimer();
    _armTimer?.cancel();
    _highlights = Map.unmodifiable({
      coordinates: CellHighlight.armed(colorOf: colorOf),
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
