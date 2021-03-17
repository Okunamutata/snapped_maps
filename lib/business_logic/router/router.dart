import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapped_maps/presentation/views/home_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final Uri routeData = Uri.parse(settings.name);
  return _getPageRoute(HomeView(), settings);
  // switch (routeData.path) {
  //   case HomeView.route:
  //     return _getPageRoute(HomeView(), settings);
  //     break;
  //   default:
  //     return _getPageRoute(HomeView(), settings);
  // }
}

MaterialPageRoute<dynamic> _getPageRoute(Widget child, RouteSettings settings) {
  return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => child, settings: settings);
}
