class Item {
  String nombre;
  double cantidad;
  String foto;
  String? searchField;
  String id;

  Item({
    required this.nombre,
    required this.cantidad,
    required this.foto,
    required this.id,
    this.searchField,
  });

  factory Item.empty() {
    return Item(
      nombre: '',
      cantidad: 0.0,
      foto: '',
      id: '',
      searchField: '',
    );
  }

  Item.fromFirestoreJson(String docId, Map<String, dynamic> json)
      : nombre = json['nombre'] as String,
        cantidad = (json['cantidad'].toDouble()) ?? 0.0,
        foto = json['foto'] as String,
        searchField =
            json['searchField'] ?? json['nombre'].toString().toLowerCase(),
        id = docId;

  Item.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        cantidad = json['cantidad'],
        foto = json['foto'],
        id = json['id'] ??
            '', // id por defecto vacio porque podemos coger datos de un formulario por ejemplo sin id
        searchField =
            json['searchField'] ?? json['nombre'].toString().toLowerCase();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['cantidad'] = cantidad;
    data['foto'] = foto;
    data['searchField'] = searchField ?? nombre.toLowerCase();
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonBD() {
    // version sin el id para almacenar en la bd de firebase sin repetir campos
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['cantidad'] = cantidad;
    data['foto'] = foto;
    data['searchField'] = searchField ?? nombre.toLowerCase();
    return data;
  }

  @override
  String toString() {
    return 'Item{id: $id, nombre: $nombre, cantidad: $cantidad, foto: $foto, searchField: $searchField}';
  }
}
