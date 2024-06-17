import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Trabajo {
  String descripcion;
  DateTime inicioTrabajo;
  DateTime finalTrabajo;
  Duration? horasTrabajadas;
  String id;

  Trabajo({
    required this.descripcion,
    required this.finalTrabajo,
    required this.id,
    required this.inicioTrabajo,
    this.horasTrabajadas,
  });

  factory Trabajo.empty() {
    return Trabajo(
      descripcion: '',
      inicioTrabajo: DateTime.now(),
      finalTrabajo: DateTime.now(),
      id: '',
      horasTrabajadas: const Duration(),
    );
  }

  Trabajo.fromFirestoreJson(String docId, Map<String, dynamic> json)
      : descripcion = json['descripcion'] as String,
        inicioTrabajo = (json['inicio_trabajo'] as Timestamp).toDate(),
        finalTrabajo = (json['final_trabajo'] as Timestamp).toDate(),
        horasTrabajadas = Duration(seconds: json['horas_trabajadas'] ?? 0),
        id = docId;

  Trabajo.fromJson(Map<String, dynamic> json)
      : descripcion = json['descripcion'] as String,
        inicioTrabajo = json['inicio_trabajo'] as DateTime,
        finalTrabajo = json['final_trabajo'] as DateTime,
        horasTrabajadas = Duration(seconds: json['horas_trabajadas'] ?? 0),
        id = json['id'] ??
            ''; // id por defecto vacio porque podemos coger datos de un formulario por ejemplo sin id

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descripcion'] = descripcion;
    data['inicio_trabajo'] = inicioTrabajo;
    data['final_trabajo'] = finalTrabajo;
    data['horas_trabajadas'] = horasTrabajadas?.inSeconds ?? 0;
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonBD() {
    // version sin el id para almacenar en la bd de firebase sin repetir campos
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descripcion'] = descripcion;
    data['inicio_trabajo'] = inicioTrabajo;
    data['final_trabajo'] = finalTrabajo;
    data['horas_trabajadas'] = horasTrabajadas?.inSeconds ?? 0;
    return data;
  }

  String get formattedInicioTrabajo =>
      DateFormat('dd-MM-yyyy HH:mm').format(inicioTrabajo);
  String get formattedFinalTrabajo =>
      DateFormat('dd-MM-yyyy HH:mm').format(finalTrabajo);

  String get formattedHorasTrabajadas =>
      '${horasTrabajadas!.inHours.toString()}:${horasTrabajadas!.inMinutes.remainder(60).toString()}';
  @override
  String toString() {
    return 'Trabajo{descripcion: $descripcion, inicioTrabajo: $inicioTrabajo, finalTrabajo: $finalTrabajo, horasTrabajadas: $horasTrabajadas, id: $id}';
  }
}
