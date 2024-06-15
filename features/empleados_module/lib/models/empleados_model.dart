import 'package:flutter/material.dart';

class Empleado {
  String nombre;
  String apellido;
  String telefono;
  String? searchField;
  String id;

  Empleado({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.id,
    this.searchField,
  });

  factory Empleado.empty() {
    return Empleado(
      nombre: '',
      apellido: '',
      telefono: '',
      id: '',
      searchField: '',
    );
  }

  Empleado.fromFirestoreJson(String docId, Map<String, dynamic> json)
      : nombre = json['nombre'] as String,
        apellido = json['apellido'] as String,
        telefono = json['telefono'] as String,
        searchField =
            json['searchField'] ?? json['nombre'].toString().toLowerCase(),
        id = docId;

  Empleado.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        apellido = json['apellido'],
        telefono = json['telefono'],
        id = json['id'] ??
            '', // id por defecto vacio porque podemos coger datos de un formulario por ejemplo sin id
        searchField =
            json['searchField'] ?? json['nombre'].toString().toLowerCase();

  static Empleado fromFormControllers({
    required Map<String, TextEditingController> formControllers,
    required String id,
    String? searchField,
  }) {
    return Empleado(
      nombre: formControllers['nombre']?.text ?? '',
      apellido: formControllers['apellido']?.text ?? '',
      telefono: formControllers['telefono']?.text ?? '',
      id: id,
      searchField: searchField ?? formControllers['nombre']?.text.toLowerCase(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['telefono'] = telefono;
    data['searchField'] = searchField ?? nombre.toLowerCase();
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonBD() {
    // version sin el id para almacenar en la bd de firebase sin repetir campos
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['telefono'] = telefono;
    data['searchField'] = searchField ?? nombre.toLowerCase();
    return data;
  }

  // Setters
  set setNombre(String value) {
    nombre = value;
  }

  set setApellido(String value) {
    apellido = value;
  }

  set setTelefono(String value) {
    telefono = value;
  }

  set setSearchField(String? value) {
    searchField = value;
  }

  set setId(String value) {
    id = value;
  }

  @override
  String toString() {
    return 'Empleado{id: $id, nombre: $nombre, apellido: $apellido, telefono: $telefono, searchField: $searchField}';
  }
}
