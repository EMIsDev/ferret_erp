import 'package:flutter/material.dart';

import '../inventario_controller.dart';

class ListaItemsPage extends StatefulWidget {
  const ListaItemsPage({super.key});
  @override
  State<ListaItemsPage> createState() => _ListaItemsPageState();
}

class _ListaItemsPageState extends State<ListaItemsPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _items = List.empty(growable: true);
  final itemsController = ItemsController();
  final Map<String, dynamic> filters = {
    'search': '',
    'limit': 20,
  };
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadItems(filters: filters);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadItems(filters: filters);
    }
  }

  Future<void> _loadItems({required Map<String, dynamic> filters}) async {
    setState(() {
      _isLoading = true;
    });

    final List<Map<String, dynamic>> items =
        await itemsController.getItems(filters: filters);
    setState(() {
      _items.addAll(items);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_items.isEmpty) {
      case false:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        filters['search'] = value;
                        _items.clear();
                        _loadItems(filters: filters);
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _items.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _items.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var item = _items[index];
                  return SizedBox(
                    height: 150, // Altura deseada para la tarjeta
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: Image.network(
                            item['foto'],
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item['nombre'].toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize:
                                    18), // Tamaño de fuente para el título
                          ),
                          subtitle: Text(
                            item['cantidad'].toString(),
                            style: const TextStyle(
                                fontSize:
                                    16), // Tamaño de fuente para el subtítulo
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case true:
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
