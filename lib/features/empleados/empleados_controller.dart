import 'package:cloud_firestore/cloud_firestore.dart';

class EmpleadosController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
