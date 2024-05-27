import 'package:ferret_erp/features/contabilidad/contabilidad_module.dart';
import 'package:ferret_erp/features/empleados/empleados_module.dart';
import 'package:ferret_erp/features/inicio/inicio_module.dart';
import 'package:ferret_erp/firebase_options.dart';
import 'package:ferret_erp/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';


Future<void> main() async{
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ModularApp(module: MainModule(), child: const MyApp()));
}

class MainModule extends Module {
  final List<ModuleRoute> _moduleRoutes = [
    ModuleRoute('/inicio/', module: InicioModule()),
    ModuleRoute('/empleados/', module: EmpleadosModule()),
    ModuleRoute('/contabilidad/', module: ContabilidadModule()),
  ];

  List<ModuleRoute> get moduleRoutes => _moduleRoutes;

 @override
  void binds(i) {
  }

  @override
  void routes(r) {
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
    return MaterialApp.router(
      title: 'FerretERP',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.amber),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amberAccent, brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      routerConfig: Modular.routerConfig,
    );
  }
}


