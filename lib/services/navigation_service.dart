import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToAndRemove(String routeName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
      routeName,
      (_) => false,
    );
  }
}
