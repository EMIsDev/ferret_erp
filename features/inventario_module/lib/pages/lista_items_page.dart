import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_module/models/item_model.dart';

import '../controllers/inventario_controller.dart';

class ListaItemsPage extends StatefulWidget {
  const ListaItemsPage({super.key});
  @override
  State<ListaItemsPage> createState() => _ListaItemsPageState();
}

class _ListaItemsPageState extends State<ListaItemsPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Item> _items = List.empty(growable: true);
  final itemsController = ItemsController();
  final Map<String, dynamic> filters = {
    'search': '',
    'limit': 15,
    'lastDocument': null,
  };
  bool _isLoading = false;
  bool _isLastPage = false;
  String? _lastDocument;

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
        !_isLoading &&
        !_isLastPage) {
      _loadItems(filters: filters);
    }
  }

  Future<bool> _deleteItem(
      {required String idItem, required String fotoUrl}) async {
    return await itemsController.deleteItem(idItem, fotoUrl);
  }

  Future<void> _loadItems({required Map<String, dynamic> filters}) async {
    setState(() {
      _isLoading = true;
    });
    filters['lastDocument'] = _lastDocument;

    final List<Item> items = await itemsController.getItems(filters: filters);
    setState(() {
      if (items.isNotEmpty) {
        _lastDocument = items.last.id;
        _items.addAll(items);
      } else {
        _isLastPage = true;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    _lastDocument = null;
                    _isLastPage = false;
                    _loadItems(filters: filters);
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: _items.isEmpty && !_isLoading
              ? const Center(
                  child: Text('No hay items con ese nombre'),
                )
              : ListView.separated(
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
                      height: 150,
                      child: Center(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: item.foto.isNotEmpty
                                ? Image.network(
                                    item.foto,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Image(
                                    image: const AssetImage(
                                        'assets/images/no-image.webp'),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                  ),
                          ),
                          title: Text(
                            item.nombre.toString().toUpperCase(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Cantidad: ${item.cantidad.toString()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  GoRouter.of(context)
                                      .go('/editarItem/${item.id}');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('ATENCIÓN!'),
                                      content: const Text(
                                          'Seguro que quieres eliminar al item?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            GoRouter.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            GoRouter.of(context).pop();
                                            debugPrint(item.id);
                                            _deleteItem(
                                                    idItem: item.id,
                                                    fotoUrl: item.foto)
                                                .then((value) {
                                              if (value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        const Text('Eliminado'),
                                                    backgroundColor:
                                                        Colors.green,
                                                    onVisible: () {
                                                      setState(() {
                                                        _items.removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Error'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: const Text('Si'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
