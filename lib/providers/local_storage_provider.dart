import 'package:flutter/material.dart';
import 'package:reaction_chain/services/local_storage.dart';

// InheritedWidget to provide LocalStorage anywhere in the widget tree.
// Similar to the ContextProvider pattern in React and web dev frameworks.
class LocalStorageProvider extends InheritedWidget {
  final LocalStorage localStorage;

  const LocalStorageProvider({
    super.key,
    required this.localStorage,
    required super.child,
  });

  static LocalStorage of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<LocalStorageProvider>();
    assert(provider != null, 'No LocalStorageProvider found in context');
    return provider!.localStorage;
  }

  @override
  bool updateShouldNotify(LocalStorageProvider oldWidget) => false;
}
