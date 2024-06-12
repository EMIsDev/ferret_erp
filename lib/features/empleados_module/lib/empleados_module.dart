library empleados_module;

import 'package:empleados_module/routes.dart';
import 'package:go_router/go_router.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

List<GoRoute> getModuleRoutesEmpleados() {
  return routes;
}
