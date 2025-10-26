import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  static final NavigationProvider _instance = NavigationProvider._internal();
  factory NavigationProvider() => _instance;
  NavigationProvider._internal();

  final GlobalKey<NavigatorState> _mainNavigatorKey =
      GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> get mainNavigatorKey => _mainNavigatorKey;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToCalculator(Widget calculator) {
    _mainNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => calculator),
    );
  }

  void popToMain() {
    while (_mainNavigatorKey.currentState?.canPop() == true) {
      _mainNavigatorKey.currentState?.pop();
    }
  }

  bool canPop() {
    return _mainNavigatorKey.currentState?.canPop() ?? false;
  }

  void pop() {
    if (canPop()) {
      _mainNavigatorKey.currentState?.pop();
    }
  }
}
