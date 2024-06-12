import 'package:ferret_erp/features/inicio/inicio_page.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
  GoRoute(path: '/inicio/', builder: (context, state) => const InicioPage()),
];
