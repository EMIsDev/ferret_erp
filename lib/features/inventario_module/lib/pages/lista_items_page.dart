import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    'limit': 15,
    'lastDocument': null,
  };
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

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

  Future<bool> _deleteItem(
      {required String idItem, required String fotoUrl}) async {
    return await itemsController.deleteItem(idItem, fotoUrl);
  }

  Future<void> _loadItems({required Map<String, dynamic> filters}) async {
    debugPrint('Loading items...');
    setState(() {
      _isLoading = true;
    });
    filters['lastDocument'] = _lastDocument;

    final List<Map<String, dynamic>> items =
        await itemsController.getItems(filters: filters);
    setState(() {
      if (items.isNotEmpty) {
        _lastDocument = items.last['docRef'] as DocumentSnapshot;
        items.removeLast(); // eliminar ultimo elemento que es docRef
      }
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
                        filters['search'] = value.toLowerCase();
                        _items.clear();
                        _lastDocument = null; //reset pagination
                        _loadItems(filters: filters);
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
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
                      height: 150, // Desired height for the card
                      child: Center(
                        child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(10), // Add padding
                            leading: SizedBox(
                              width: 50, // Set a fixed width for the image
                              height: 50, // Set a fixed height for the image
                              child: item['foto'] != null
                                  ? Image.network(
                                      item['foto'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    )
                                  : Image.asset('assets/images/no-image.webp',
                                      fit: BoxFit.cover),
                            ),
                            title: Text(
                              item['nombre'].toString().toUpperCase(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              'Cantidad: ${item['cantidad']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .go('/editarItem/${item['id']}');
                                  },
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                  title:
                                                      const Text('ATENCIÓN!'),
                                                  content: const Text(
                                                      'Seguro que quieres eliminar al item?'),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          GoRouter.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('No')),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        GoRouter.of(context)
                                                            .pop();
                                                        debugPrint(item['id']);
                                                        _deleteItem(
                                                                idItem:
                                                                    item['id'],
                                                                fotoUrl: item[
                                                                    'foto'])
                                                            .then((value) {
                                                          if (value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: const Text(
                                                                    'Eliminado'),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                onVisible: () {
                                                                  setState(() {
                                                                    _items.removeAt(
                                                                        index);
                                                                  });
                                                                },
                                                              ),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Error'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        });
                                                      },
                                                      child: const Text('Si'),
                                                    ),
                                                  ]));
                                    }),
                              ],
                            )),
                      ));
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
