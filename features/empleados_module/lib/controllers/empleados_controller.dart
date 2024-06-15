import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empleados_module/models/empleados_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EmpleadosController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm');
  final onlyDayFormat = DateFormat('dd-MM-yyyy');
  final onlyHourFormat = DateFormat('hh:mm');

  Future<List<Object?>> getEmpleados() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('empleados').get();
      List<Object?> empleados =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return empleados;
    } catch (e) {
      debugPrint('Error getting empleados: $e');
      return [];
    }
  }

  Future<Empleado?> getEmpleadoById({required empleadoId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('empleados').doc(empleadoId).get();
      Empleado empleado = Empleado.fromFirestoreJson(
          documentSnapshot.id, documentSnapshot.data() as Map<String, dynamic>);
      return empleado;
    } catch (e) {
      debugPrint('Error getting empleado by id: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getEmpleadoTrabajos(
      {required String empleadoId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('empleados').doc(empleadoId).get();
      if (snapshot.data()?['lista_trabajos'] != null) {
        List<Map<String, dynamic>> dataList = [];
        for (DocumentReference reference
            in snapshot.data()?['lista_trabajos']) {
          DocumentSnapshot snapshot = await reference.get();
          if (snapshot.exists) {
            Map<String, dynamic> data =
                snapshot.data()! as Map<String, dynamic>;
            data['inicio_trabajo'] =
                dateFormat.format(data['inicio_trabajo'].toDate());
            data['final_trabajo'] =
                dateFormat.format(data['final_trabajo'].toDate());
            dataList.add(data);
          } else {
            debugPrint('Document with reference ${reference.path} not found.');
          }
        }
        return dataList;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting empleado trabajos: $e');
      return null; // Indicate error
    }
  }

  Future<List<Map<String, dynamic>>?> getEmpleadosIdAndName() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('empleados').get();
      List<Map<String, dynamic>> empleados = querySnapshot.docs
          .map((doc) => {'id': doc.id, 'nombre': doc['nombre']})
          .toList();

      return empleados;
    } catch (e) {
      debugPrint('Error getting empleados: $e');
      return [];
    }
  }

  Future<bool> addEmpleado(Empleado empleado) async {
    try {
      await _firestore.collection('empleados').add(empleado.toJsonBD());
      return true;
    } catch (e) {
      debugPrint('Error adding empleado: $e');
      return false;
    }
  }

  Future<bool> updateEmpleado({required Empleado updatedEmpleado}) async {
    try {
      await _firestore.collection('empleados').doc(updatedEmpleado.id).update(
          updatedEmpleado.toJsonBD()); // elimino id para no repetir en la bd
      return true; // Update successful
    } catch (e) {
      debugPrint('Error updating empleado: $e');
      return false; // Update failed
    }
  }

  Future<bool> deleteEmpleado(String empleadoId) async {
    try {
      await _firestore.collection('empleados').doc(empleadoId).delete();
      return true; // Delete successful
    } catch (e) {
      debugPrint('Error deleting empleado: $e');
      return false; // Delete failed
    }
  }

  Future<bool> addWorkToEmployee(
      {required List<Map<String, dynamic>> empleados,
      required Map<String, dynamic> trabajo}) async {
    try {
      // Calculo de horas trabajadas
      DateTime inicioTrabajo = trabajo['fecha_inicio_trabajo'];
      DateTime finalTrabajo = trabajo['fecha_final_trabajo'];

      int diasTrabajados = finalTrabajo.difference(inicioTrabajo).inDays ==
              0 //si es el mismo dia se suma 1
          ? 1
          : finalTrabajo.difference(inicioTrabajo).inDays;

      //calculate the total of hours worked with horaInicio and HoraFinal
      int horasTrabajadas = finalTrabajo.difference(inicioTrabajo).inHours;
      int minutosTrabajados =
          finalTrabajo.difference(inicioTrabajo).inMinutes % 60;
      print('Horas trabajadas: $horasTrabajadas');
      print('Minutos trabajados: $minutosTrabajados');
      // Crear trabajo con horas y minutos trabajados
      double horasTrabajadasDecimal =
          horasTrabajadas + (minutosTrabajados / 60);

      Map<String, dynamic> trabajoConHoras = {
        'descripcion': trabajo['descripcion'],
        'inicio_trabajo': trabajo['fecha_inicio_trabajo'],
        'final_trabajo': trabajo['fecha_final_trabajo'],
        'horas_trabajadas': '${horasTrabajadas}:${minutosTrabajados}h',
      };

      // Agregar trabajo a la coleccion de trabajos
      DocumentReference trabajoRef =
          await _firestore.collection('trabajos').add(trabajoConHoras);
      // Agregar referencia del trabajo a cada empleado
      for (Map<String, dynamic> empleado in empleados) {
        DocumentReference empleadoRef =
            _firestore.collection('empleados').doc(empleado['id']);
        await empleadoRef.update({
          'lista_trabajos': FieldValue.arrayUnion([trabajoRef])
        });
      }
      return true;
    } catch (e) {
      debugPrint('Error adding work to employee: $e');
      return false;
    }
  }

  Future<void> putMockData() async {
    try {
      final data =
          await rootBundle.loadString('assets/MOCK_DATA_empleados.json');
      final List<dynamic> itemsList = jsonDecode(data);
      final List<Map<String, dynamic>> items =
          itemsList.cast<Map<String, dynamic>>();

      for (var item in items) {
        // Asigna un ID generado automáticamente
        await _firestore.collection('empleados').add(item);
      }
    } catch (e) {
      debugPrint('Error putting mock data: $e');
    }
  }

  Future<void> insensitiveCase() async {
    try {
      Query query = _firestore.collection('empleados');

      QuerySnapshot items = await query.get();

      for (var item in items.docs) {
        // Asigna un ID generado automáticamente
        await _firestore
            .collection('empleados')
            .doc(item.id)
            .update({'searchField': item['nombre'].toString().toLowerCase()});
      }
    } catch (e) {
      debugPrint('Error putting mock data: $e');
    }
  }
}
