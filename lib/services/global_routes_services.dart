import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

Future<List<GoRoute>> getDynamicModuleRoutes() async {
  final modulesDir = Directory('lib/features');
  final modulePaths = modulesDir
      .listSync(recursive: true)
      .where((entity) => entity is Directory)
      .map((entity) => entity.path)
      .toList();
  List<GoRoute> dynamicModuleRoutes = <GoRoute>[];

  for (final modulePath in modulePaths) {
    final routesPath = '$modulePath/lib/routes.dart';
    if (File(routesPath).existsSync()) {
      try {
        final moduleRoutes = await loadRoutesFromModule(routesPath);
        dynamicModuleRoutes.addAll(moduleRoutes);
      } catch (error) {
        print('Error loading routes from $routesPath: $error');
        // Handle the error gracefully (e.g., return an empty route)
      }
    }
  }

  return dynamicModuleRoutes;
}

// Función auxiliar para cargar rutas desde un módulo
Future<List<GoRoute>> loadRoutesFromModule(String routesPath) async {
  final routesString = await rootBundle.loadString(routesPath);

  // Procesar el contenido del archivo para extraer las rutas
  final routesList = _parseRoutesFromContent(routesString);

  // Convertir las rutas a objetos GoRoute
  return routesList.map((routeMap) => _createGoRoute(routeMap)).toList();
}

// Función auxiliar para analizar el contenido del archivo y extraer las rutas (implementación básica)
List<Map<String, dynamic>> _parseRoutesFromContent(String routesContent) {
  // Analiza el contenido del archivo para extraer las rutas en formato de lista de mapas
  // Puedes utilizar expresiones regulares o librerías de análisis de código fuente
  // ...

  // Ejemplo simplificado (asumiendo un formato JSON simple)
  final routesList = jsonDecode(routesContent) as List<dynamic>;
  return routesList.cast<Map<String, dynamic>>();
}

// Función auxiliar para crear objetos GoRoute (opcional si la estructura de rutas es diferente)
GoRoute _createGoRoute(Map<String, dynamic> routeMap) {
  final name = routeMap['name'] as String;
  final path = routeMap['path'] as String;
  final builder = routeMap['builder'] as Function; // May need casting

  return GoRoute(
    name: name,
    path: path,
    builder: builder as Widget Function(BuildContext, GoRouterState)?,
  );
}
