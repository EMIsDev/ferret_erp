import 'package:go_router/go_router.dart';
import 'package:inicio_module/inicio_page.dart';

final List<GoRoute> routes = [
  GoRoute(path: '/inicio', builder: (context, state) => const InicioPage()),
];
