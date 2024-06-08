import 'package:flutter_modular/flutter_modular.dart';

class GlobalRoutesService {
  static final List<Map<String, dynamic>> moduleRoutes = [{}];
  late final dynamic mainModule;
  static final GlobalRoutesService _globalRoutesService =
      GlobalRoutesService._internal();

  factory GlobalRoutesService() {
    return _globalRoutesService;
  }
  GlobalRoutesService._internal();

  void addAllRoutes(List<Map<String, dynamic>> routes) {
    moduleRoutes.addAll(routes);
  }

  void setMainModule(Module module) {
    mainModule = module;
  }

  List<Map<String, dynamic>> get allRoutes => moduleRoutes;
  void navigateTo(String route) {
    Modular.to.navigate(route);
  }
}
