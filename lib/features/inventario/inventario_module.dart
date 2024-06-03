import 'package:ferret_erp/features/inventario/inventario_page.dart';
import 'package:ferret_erp/features/inventario/pages/agregar_item_page.dart';
import 'package:ferret_erp/features/inventario/pages/editar_item_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'pages/lista_items_page.dart';

class InventarioModule extends Module {
  final List<ChildRoute> _moduleRoutes = [
    ChildRoute('/listaItems/', child: (context) => const ListaItemsPage()),
    ChildRoute('/agregarItem/', child: (context) => const AgregarItemPage()),
    ChildRoute('/editarItem/:idItem',
        child: (context) => EditarItem(idItem: Modular.args.params['idItem'])),
  ];

  List<ChildRoute> get moduleRoutes => _moduleRoutes;
  @override
  void routes(r) {
    r.child('/',
        child: (context) => const ContabilidadPage(), children: _moduleRoutes);
  }
}
