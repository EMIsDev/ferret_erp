import 'package:ferret_erp/features/empleados/empleados_module.dart';
import 'package:ferret_erp/features/inicio/inicio_module.dart';
import 'package:ferret_erp/features/inventario/inventario_module.dart';
import 'package:ferret_erp/firebase_options.dart';
import 'package:ferret_erp/main_page.dart';
import 'package:ferret_erp/services/global_routes_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ModularApp(module: MainModule(), child: const MyApp()));
}

class MainModule extends Module {
  final List<ModuleRoute> _moduleRoutes = [
    ModuleRoute('/inicio/', module: InicioModule()),
    ModuleRoute('/empleados/', module: EmpleadosModule()),
    ModuleRoute('/inventario/', module: InventarioModule()),
  ];
  MainModule() {
    GlobalRoutesService().setMainModule(this);
  }
  List<ModuleRoute> get moduleRoutes => _moduleRoutes;

  @override
  void binds(i) {
    i.addSingleton(GlobalRoutesService.new, key: 'ListAllRoutes');
  }

  @override
  void routes(r) {
    //EmpleadosModule().routes(r);
    //GlobalRoutesService globalRouteService = Modular.get(key: 'ListAllRoutes');

    //globalRouteService.addAllRoutes(MainModule().moduleRoutes);
    r.child('/',
        child: (context) => const MainPage(),
        children: _moduleRoutes,
        transition: TransitionType.fadeIn);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*final GlobalRoutesService globalRouteService =
        Modular.get(key: 'ListAllRoutes');
    globalRouteService.addAllRoutes(MainModule().moduleRoutes);

    globalRouteService
        .allRoutes.forEach((e) {
      print(e.name);
      /*e.innerModules.forEach((key, value) {
        print('  ${key.toString()}');
        print(Modular.tryGet<ModuleRoute>(key: key.toString()));
      });*/
      print(e.children);
      //  print(Modular.routerConfig.routeInformationProvider);
    });*/
    return MaterialApp.router(
      title: 'FerretERP',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.amber),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amberAccent, brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      routerConfig: Modular.routerConfig,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
    );
  }
}
