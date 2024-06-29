import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class RouteConfig {
  List<RouteInfo> getRoutes();
}

class RouteInfo {
  final String path;
  final String name;
  final IconData icon;
  final GoRouterWidgetBuilder builder;

  RouteInfo({
    required this.path,
    required this.name,
    required this.icon,
    required this.builder,
  });
}
