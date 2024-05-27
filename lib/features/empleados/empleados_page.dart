import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmpleadosPage extends StatelessWidget {
  const EmpleadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Column(
            children: [
              Text('ejemplo'),
            ],
          ),
        ),
        Placeholder()
      ],
    );
  }
}

/*
Scaffold(
      body: Row(
        children: [
          // Navigation Menu
          Container(
            width: 200,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.home),
                      Text('Inicio'),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      Text('Usuarios'),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      Text('Configuración'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Replace with actual data source
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item ${index + 1}'),
                      // Add more content as needed
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
 */