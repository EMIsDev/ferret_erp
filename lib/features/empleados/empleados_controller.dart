import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EmpleadosController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm');

  Future<List<Object?>> getEmpleados() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('empleados').get();
      List<Object?> empleados =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return empleados;
    } catch (e) {
      print('Error getting empleados: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getEmpleadoById({required empleadoId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('empleados').doc(empleadoId).get();
      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting empleado by id: $e');
      return {};
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
            print('Document with reference ${reference.path} not found.');
          }
        }
        return dataList;
      }
      return null;
    } catch (e) {
      print('Error getting empleado trabajos: $e');
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
      print('Error getting empleados: $e');
      return [];
    }
  }

  Future<bool> addEmpleado(Map<String, dynamic> empleado) async {
    try {
      await _firestore.collection('empleados').add(empleado);
      return true;
    } catch (e) {
      print('Error adding empleado: $e');
      return false;
    }
  }

  Future<bool> updateEmpleado(
      {required String idTrabajador,
      required Map<String, dynamic> updatedData}) async {
    try {
      await _firestore
          .collection('empleados')
          .doc(idTrabajador)
          .update(updatedData); // elimino id para no repetir en la bd
      return true; // Update successful
    } catch (e) {
      print('Error updating empleado: $e');
      return false; // Update failed
    }
  }

  Future<bool> deleteEmpleado(String empleadoId) async {
    try {
      await _firestore.collection('empleados').doc(empleadoId).delete();
      return true; // Delete successful
    } catch (e) {
      print('Error deleting empleado: $e');
      return false; // Delete failed
    }
  }

  Future<void> addWorkToEmployee(
      {required List<Map<String, dynamic>> empleados,
      required Map<String, dynamic> trabajo}) async {
    try {
      // Calculo de horas trabajadas
      DateTime inicioTrabajo = trabajo['fecha_inicio'];
      DateTime finalTrabajo = trabajo['fecha_final'];
      int diasTrabajados = finalTrabajo.difference(inicioTrabajo).inDays;

      DateTime horaInicio = trabajo['hora_inicio_trabajo'];
      DateTime horaFinal = trabajo['hora_final_trabajo'];
      //calculate the total of hours worked with horaInicio and HoraFinal
      int horasTrabajadas = horaFinal.difference(horaInicio).inHours;
      int minutosTrabajados = horaFinal.difference(horaInicio).inMinutes % 60;
      // Crear trabajo con horas y minutos trabajados
      double horasTrabajadasDecimal =
          horasTrabajadas + (minutosTrabajados / 60);

      Map<String, dynamic> trabajoConHoras = {
        'descripcion': trabajo['descripcion'],
        'inicio_trabajo': trabajo['fecha_inicio'],
        'final_trabajo': trabajo['fecha_final'],
        'horas_trabajadas': DateFormat('HH:mm')
            .format(DateTime(0, 0, 0, horasTrabajadas, minutosTrabajados))
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
    } catch (e) {
      print('Error adding work to employee: $e');
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
      print('Error putting mock data: $e');
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
      print('Error putting mock data: $e');
    }
  }
}
