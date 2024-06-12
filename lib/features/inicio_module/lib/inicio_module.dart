library inicio_module;

import 'package:go_router/go_router.dart';
import 'package:inicio_module/routes.dart';

export 'inicio_page.dart';
export 'routes.dart';

List<GoRoute> getModuleRoutes() {
  return routes;
}
