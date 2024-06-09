import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({super.key});

  @override
  State<CustomSideMenu> createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  bool _isCollapsed = false;

  void _toggleMenu() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _updateTitle(String title) {
    // Add your update title logic here
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Set fixed widths
    double expandedWidth = 200.0;
    double collapsedWidth = 60.0;

    // Check if screen width is less than a threshold to collapse menu
    if (screenWidth < 400.0) {
      _isCollapsed = true;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height,
      width: _isCollapsed ? collapsedWidth : expandedWidth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleMenu,
            ),
            _isCollapsed
                ? Column(
                    children: [
                      _buildCollapsedIcon(Icons.home, '/inicio/'),
                      _buildCollapsedIcon(Icons.person, '/empleados/'),
                      _buildCollapsedIcon(Icons.inventory, '/inventario/'),
                    ],
                  )
                : Column(
                    children: [
                      _buildMenuItem(Icons.home, 'Inicio', '/inicio/'),
                      _buildExpansionMenu(
                        Icons.person,
                        'Empleados',
                        [
                          _buildMenuItem(Icons.handyman, 'Agregar Trabajo',
                              '/empleados/agregarTrabajo/'),
                          _buildMenuItem(Icons.history, 'Historial Trabajo',
                              '/empleados/historialTrabajo/'),
                          _buildMenuItem(Icons.edit, 'Editar Empleado',
                              '/empleados/editarEmpleado/'),
                          _buildMenuItem(Icons.person_add, 'Agregar Empleado',
                              '/empleados/agregarEmpleado/'),
                        ],
                      ),
                      _buildExpansionMenu(
                        Icons.inventory,
                        'Inventario',
                        [
                          _buildMenuItem(Icons.list, 'Lista Item',
                              '/inventario/listaItems/'),
                          _buildMenuItem(Icons.add, 'Agregar Item',
                              '/inventario/agregarItem/'),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionMenu(
      IconData icon, String title, List<Widget> children) {
    return ExpansionTile(
      leading: SizedBox(width: 5, child: Icon(icon)),
      title: _isCollapsed ? const SizedBox.shrink() : Text(title),
      children: _isCollapsed ? [] : children,
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        leading: SizedBox(width: 5, child: Icon(icon)),
        title: Text(title),
        onTap: () {
          Modular.to.navigate(route);
        },
      ),
    );
    /*  return InkWell(
      onTap: () {
        Modular.to.navigate(route);
      },
      child: Row(
        children: [
          Icon(icon),
          if (!_isCollapsed) ...[
            const SizedBox(width: 10),
            Text(title),
          ],
        ],
      ),
    );*/
  }

  Widget _buildCollapsedIcon(IconData icon, String route) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        Modular.to.navigate(route);
      },
    );
  }
}
