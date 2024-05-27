import 'package:ferret_erp/main_module.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
            for (final route in MainModule().moduleRoutes)
            ListTile(
              title: Text(route.name.replaceAll('/', '').toUpperCase()),
              onTap: () {
                Modular.to.pop(); // Close the drawer
                _updateTitle(route.name.replaceAll('/', '').toUpperCase());
                  Modular.to.navigate(route.name );
              },
            ),
        ]
      )),
      body: const Column(
        // Or Row depending on your layout
        children: [
          Expanded(child: RouterOutlet()),
        ],
      ),
    );
  }

  void _updateTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }
}