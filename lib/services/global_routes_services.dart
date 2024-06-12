import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

class GlobalRoutesService {
  static List<GoRoute> getAllRoutes() {
    List<GoRoute> routes = [];

    final featuresDir = Directory('lib/features');
    if (featuresDir.existsSync()) {
      final featureFolders = featuresDir.listSync().whereType<Directory>();
      for (var folder in featureFolders) {
        final routesFile = File(p.join(folder.path, 'routes.dart'));
        if (routesFile.existsSync()) {
          final moduleRoute = _getRouteFromFile(routesFile);
          routes.add(moduleRoute);
        }
      }
    }

    return routes;
  }

  static GoRoute _getRouteFromFile(File file) {
    // Utiliza reflexión para cargar y obtener rutas desde el archivo
    final moduleName = p.basename(file.parent.path);
    final libraryMirror = currentMirrorSystem().findLibrary(Symbol(moduleName));
    final classMirror =
        libraryMirror.declarations[Symbol('${moduleName}Routes')];
    final routeMethod = classMirror.staticMembers[const Symbol('getRoute')]!;
    final route =
        classMirror.invoke(routeMethod.simpleName, []).reflectee as GoRoute;
    return route;
  }
}
