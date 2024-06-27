import 'package:empleados_module/empleados_module.dart';
import 'package:ferret_erp/firebase_options.dart';
import 'package:ferret_erp/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:inicio_module/inicio_module.dart';
import 'package:inventario_module/inventario_module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<Map<String, dynamic>> routesList = getAllRoutes();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/inicio',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return MainPage(sideItems: routesList, widgetChild: child);
          },
          routes: extractRoutes(routesList).map((route) {
            return route.copyWith(
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: route.builder!(context, state),
                  transitionsBuilder: defaultPageTransition,
                );
              },
            );
          }).toList(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'FerretERP',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.amber),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amberAccent, brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
    );
  }
}

List<Map<String, dynamic>> getAllRoutes() {
  final List<Map<String, dynamic>> routes = [];
  routes.add(getInicioModuleRoutes());

  routes.add(getEmpleadosModuleRoutes());

  routes.add(getInventarioModuleRoutes());
  return routes;
}

List<GoRoute> extractRoutes(List<Map<String, dynamic>> routesList) {
  List<GoRoute> goRoutes = [];
  for (var module in routesList) {
    var nestedRoutes = module['routes'] as List<dynamic>;
    for (var nestedRoute in nestedRoutes) {
      if (nestedRoute is Map<String, dynamic>) {
        GoRoute? route = nestedRoute['route'] as GoRoute?;
        if (route != null) {
          goRoutes.add(route);
        }
      }
    }
  }
  return goRoutes;
}

Widget defaultPageTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    ),
    child: child,
  );
}

extension GoRouteExtension on GoRoute {
  GoRoute copyWith({
    GoRouterPageBuilder? pageBuilder,
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      builder: builder,
      routes: routes,
      redirect: redirect,
    );
  }
}
