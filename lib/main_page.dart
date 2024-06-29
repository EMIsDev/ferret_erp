import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget widgetChild;
  final List<Map<String, dynamic>> sideItems;
  const MainPage(
      {super.key, required this.widgetChild, required this.sideItems});

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
        _buildSideMenu(
            itemList: widget.sideItems, sideMenuController: sideMenuController),
        //CustomSideMenu(),
        const VerticalDivider(
          width: 0,
        ),
        Expanded(child: widget.widgetChild),
        //  const Expanded(child: RouterOutlet())
      ]),
    );
  }

  Widget _buildSideMenu(
      {required List<Map<String, dynamic>> itemList,
      required SideMenuController sideMenuController}) {
    return SideMenu(
      controller: sideMenuController,
      style: SideMenuStyle(
        openSideMenuWidth: 215,
        // showTooltip: false,

        displayMode: SideMenuDisplayMode.auto,
        showHamburger: true,
        hoverColor: Colors.blue[100],
        selectedHoverColor: Colors.blue[100],
        backgroundColor: Colors.grey[200],
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        // ),
      ),
      items: itemList.map((item) {
        switch ((item['routes'] as List).length) {
          case > 1:
            return SideMenuExpansionItem(
              title: item['nombre_modulo'] as String,
              icon: item.containsKey('icon') && item['icon'] != null
                  ? item['icon'] as Icon
                  : null,
              children: (item['routes'] as List)
                  .where((subItem) => !(subItem.containsKey(
                          'sidebarView') && // filtramos para conseguir los que si queremos que se  muestren en el sidebar
                      subItem['sidebarView'] == false))
                  .map<SideMenuItem>((subItem) {
                return SideMenuItem(
                  title: (subItem['route'] as GoRoute).name ?? 'No Name',
                  onTap: (index, _) {
                    sideMenuController.changePage(index);
                    _updateTitle(
                        (subItem['route'] as GoRoute).name ?? 'No Name');
                    GoRouter.of(context).go((subItem['route'] as GoRoute).path);
                  },
                  icon: subItem.containsKey('icon') && subItem['icon'] != null
                      ? subItem['icon'] as Icon
                      : null,
                );
              }).toList(),
            );

          case == 1:
            return SideMenuItem(
              title: item['nombre_modulo'] as String,
              onTap: (index, _) {
                sideMenuController.changePage(index);
                _updateTitle(item['nombre_modulo'] as String);
                GoRouter.of(context)
                    .go((item['routes'][0]['route'] as GoRoute).path);
              },
              icon: item['routes'][0].containsKey('icon') &&
                      item['routes'][0]['icon'] != null
                  ? item['routes'][0]['icon'] as Icon
                  : null,
            );
        }
      }).toList(),
    );
  }

  void _updateTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }
}
