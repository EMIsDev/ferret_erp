import 'package:empleados_module/controllers/empleados_controller.dart';
import 'package:empleados_module/empleados_module.dart';
import 'package:empleados_module/models/empleados_model.dart';
import 'package:empleados_module/models/trabajos_model.dart';
import 'package:ferret_erp/firebase_options.dart';
import 'package:ferret_erp/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:inicio_module/inicio_module.dart';
import 'package:inventario_module/controllers/inventario_controller.dart';
import 'package:inventario_module/inventario_module.dart';
import 'package:inventario_module/models/item_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await executeAllTestController();

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

Future<void> executeAllTestController() async {
//  await testEmpleadoController();
  await testInventarioController();
}

Future<void> testEmpleadoController() async {
  group('EmpleadosController', () {
    test('Test getEmpleadoById', () async {
      final controller = EmpleadosController();
      const empleadoId = 'GU2QRKm4rQlIBHbtetOc';

      final result = await controller.getEmpleadoById(empleadoId: empleadoId);

      expect(result, isNotNull);
    });

    test('Test getEmpleadoTrabajos', () async {
      final controller = EmpleadosController();
      const empleadoId = 'GU2QRKm4rQlIBHbtetOc';
      final filters = {
        'rango_trabajo': DateTimeRange(
          start: DateTime.parse('2024-06-17 00:00:00Z'),
          end: DateTime.parse('2024-06-18 00:00:00Z'),
        ),
      };

      final result = await controller.getEmpleadoTrabajos(
        empleadoId: empleadoId,
        filters: filters,
      );

      expect(result, isNotEmpty);
    });

    test('Test getEmpleadosIdAndName', () async {
      final controller = EmpleadosController();

      final result = await controller.getEmpleadosIdAndName();

      expect(result, isNotEmpty);
    });

    test('Test addEmpleado', () async {
      final controller = EmpleadosController();
      final empleado = Empleado(
        nombre: 'Test',
        apellido: 'Test',
        telefono: '666666666',
        id: '',
      );

      final result = await controller.addEmpleado(empleado);

      expect(result, isTrue);
    });

    test('Test updateEmpleado', () async {
      final controller = EmpleadosController();
      final updatedEmpleado = Empleado(
        nombre: 'EmiTEST',
        apellido: 'Emi',
        telefono: '666666666',
        id: 'GU2QRKm4rQlIBHbtetOc',
      );

      final result =
          await controller.updateEmpleado(updatedEmpleado: updatedEmpleado);

      expect(result, isTrue);
    });

    test('Test deleteEmpleado', () async {
      final controller = EmpleadosController();
      const empleadoId = 'pTyy0epu5oGCDqkY3D47';

      final result = await controller.deleteEmpleado(empleadoId);

      expect(result, isTrue);
    });

    test('Test addWorkToEmployee', () async {
      final controller = EmpleadosController();
      final empleados = [
        {'id': 'ZG1Nh0VnZLVFQA2MoPYd', 'nombre': 'Kstor'},
        {'id': '4Aw33Lhxc1YE7VeLZW0f', 'nombre': 'Sandra'},
      ];
      final trabajo = Trabajo(
        descripcion: 'Test',
        inicioTrabajo: DateTime.now(),
        finalTrabajo: DateTime.now(),
        id: '',
      );

      final result = await controller.addWorkToEmployee(
        empleados: empleados,
        trabajo: trabajo,
      );

      expect(result, isTrue);
    });
  });
}

Future<void> testInventarioController() async {
  group('ItemsController', () {
    late ItemsController itemsController;

    setUp(() {
      itemsController = ItemsController();
    });

    test('getItems', () async {
      final items = await itemsController.getItems();
      expect(items, isA<List<Item>>());
    });

    test('deleteItem', () async {
      const itemId = '1W79SYf4mKH4hDy58Ifc';
      const fotoUrl =
          'https://firebasestorage.googleapis.com/v0/b/ferret-erp.appspot.com/o/items%2Ffbb96265-69cf-4e3f-9eab-058624f18130.jpg?alt=media&token=1d6a95c0-6691-40d0-b43a-392f178b0c76';
      final result = await itemsController.deleteItem(itemId, fotoUrl);
      expect(result, isTrue);
    });

    test('addItem', () async {
      final newItem = Item(
        id: '',
        cantidad: 20.0,
        nombre: 'Dragoncito',
        foto:
            'C:/Users/emili/Downloads/bd0550ee-1a3f-4c6d-8dc8-08fb2751c9ff.png',
      );
      final itemId = await itemsController.addItem(newItem: newItem);
      expect(itemId, isNotEmpty);
    });

    test('getItemById ', () async {
      const itemId = '0gyGQWRYdG3MD5y1TE6g';
      final item = await itemsController.getItemById(itemId: itemId);
      expect(item, isA<Item>());
    });

    test('updateItem ', () async {
      final updatedItem = Item(
        id: '0gyGQWRYdG3MD5y1TE6g',
        cantidad: 2.0,
        nombre: "Silla",
        foto:
            "https://firebasestorage.googleapis.com/v0/b/ferret-erp.appspot.com/o/items%2Fsilla_madera.webp?alt=media&token=3b2b5598-ab62-4a82-9471-260fa8a30207",
      );
      const newFoto = '';
      final result = await itemsController.updateItem(
        updatedItem: updatedItem,
        newFoto: newFoto,
      );
      expect(result, isTrue);
    });
  });
}
