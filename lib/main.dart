import 'package:ferret_erp/features/contabilidad/contabilidad_page.dart';
import 'package:ferret_erp/features/gestion_empleados/gest_empleados_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  //runApp(const MyApp());
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/',
        child: (context) => const HomePage(),
        children: [
          ChildRoute('/first', child: (context) => const ContabilidadPage()),
          ChildRoute('/second', child: (context) => const SecondPage())
        ],
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final leading = SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        children: [
          ListTile(
            title: const Text('Contabilidad'),
            onTap: () => Modular.to.navigate('/first'),
          ),
          ListTile(
            title: const Text('Empleados'),
            onTap: () => Modular.to.navigate('/second'),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Row(
        children: [
          leading,
          Container(width: 2, color: Colors.black45),
          const Expanded(child: RouterOutlet()),
        ],
      ),
    );
  }
}
