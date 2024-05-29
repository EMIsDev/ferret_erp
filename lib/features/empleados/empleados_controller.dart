import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addEmpleado(Map<String, dynamic> empleado) async {
    try {
      await _firestore.collection('empleados').add(empleado);
    } catch (e) {
      print('Error adding empleado: $e');
    }
  }

  Future<void> updateEmpleado(
      String empleadoId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('empleados')
          .doc(empleadoId)
          .update(updatedData);
    } catch (e) {
      print('Error updating empleado: $e');
    }
  }

  Future<void> deleteEmpleado(String empleadoId) async {
    try {
      await _firestore.collection('empleados').doc(empleadoId).delete();
    } catch (e) {
      print('Error deleting empleado: $e');
    }
  }
}
