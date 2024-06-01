import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _title = 'Home Page'; // Initial title
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SideMenuController sideMenuController = SideMenuController();

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        _buildSideMenu(sideMenuController: sideMenuController),
        const VerticalDivider(
          width: 0,
        ),
        const Expanded(child: RouterOutlet())
      ]),
    );
  }

  Widget _buildSideMenu({required SideMenuController sideMenuController}) {
    return SideMenu(
        style: SideMenuStyle(
            openSideMenuWidth: 215,
            // showTooltip: false,
            displayMode: SideMenuDisplayMode.auto,
            showHamburger: true,
            hoverColor: Colors.blue[100],
            selectedHoverColor: Colors.blue[100],
            selectedColor: Colors.lightBlue,
            selectedTitleTextStyle: const TextStyle(color: Colors.black),
            selectedIconColor: Colors.black,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            backgroundColor: Colors.grey[200]),
        items: [
          SideMenuItem(
            title: 'Inicio',
            onTap: (index, _) {
              sideMenuController.changePage(index);
              Modular.to.navigate('/inicio/');
            },
            icon: const Icon(Icons.home),
          ),
          SideMenuExpansionItem(
            title: "Empleados",
            icon: const Icon(Icons.person),
            children: [
              SideMenuItem(
                title: 'Agregar Trabajo',
                onTap: (index, _) {
                  sideMenuController.changePage(index);
                  _updateTitle('Agregar Trabajo');
                  Modular.to.navigate('/empleados/agregarTrabajo/');
                },
                icon: const Icon(Icons.handyman),
              ),
              SideMenuItem(
                title: 'Historial Trabajo',
                onTap: (index, _) {
                  sideMenuController.changePage(index);
                  _updateTitle('Historial Trabajo');
                  Modular.to.navigate('/empleados/historialTrabajo/');
                },
                icon: const Icon(Icons.history),
              ),
              SideMenuItem(
                title: 'Editar Empleado',
                onTap: (index, _) {
                  _updateTitle('Editar Empleado');
                  Modular.to.navigate('/empleados/editarEmpleado/');

                  sideMenuController.changePage(index);
                },
                icon: const Icon(Icons.edit),
              ),
              SideMenuItem(
                title: 'Agregar Empleado',
                onTap: (index, _) {
                  _updateTitle('Agregar Empleado');

                  sideMenuController.changePage(index);
                  Modular.to.navigate('/empleados/agregarEmpleado/');
                },
                icon: const Icon(Icons.watch),
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Inventario",
            icon: const Icon(Icons.inventory),
            children: [
              SideMenuItem(
                title: 'Lista Item',
                onTap: (index, _) {
                  sideMenuController.changePage(index);
                  _updateTitle('Lista Item');
                  Modular.to.navigate('/inventario/listaItems/');
                },
                icon: const Icon(Icons.list),
              ),
              SideMenuItem(
                title: 'Agregar Items',
                onTap: (index, _) {
                  sideMenuController.changePage(index);
                  _updateTitle('Agregar Items');
                  Modular.to.navigate('/inventario/agregarItem/');
                },
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
        controller: sideMenuController);
  }

  void _updateTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }
}

/*
for (final route in MainModule().moduleRoutes)
          ListTile(
            title: Text(route.name.replaceAll('/', '').toUpperCase()),
            onTap: () {
              Modular.to.pop(); // Close the drawer
              _updateTitle(route.name.replaceAll('/', '').toUpperCase());
              Modular.to.navigate(route.name);
            },
          ),
 */