import 'package:ferret_erp/features/empleados_module/lib/empleados_module.dart';
import 'package:ferret_erp/features/inicio_module/lib/inicio_module.dart';
import 'package:ferret_erp/firebase_options.dart';
import 'package:ferret_erp/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _router = GoRouter(initialLocation: '/agregarTrabajo', routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(widgetChild: child);
      },
      routes: [...getModuleRoutes(), ...getModuleRoutesEmpleados()],
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    print(getModuleRoutes());
    return MaterialApp.router(
      title: 'FerretERP',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.amber),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amberAccent, brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
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
