import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName,
      {Map<String, String> queryParams}) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithObject(String routeName,
      {Map<String, Map<String, dynamic>> queryParams}) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: {
        'id': queryParams['id']['id'],
      }).toString();
    }
    return navigatorKey.currentState.pushNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
