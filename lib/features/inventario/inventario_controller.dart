import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class ItemsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getItems(
      {Map<String, dynamic> filters = const {
        'limit': 20,
        'search': '',
        'lastDocument': null
      }}) async {
    try {
      String search = filters['search'] ?? '';
      int limit = filters['limit'] ?? 20;
      DocumentSnapshot? lastDocument = filters['lastDocument'];

      Query query = _firestore.collection('items').limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      if (search.isNotEmpty) {
        query = query
            .where('searchField', isGreaterThanOrEqualTo: search)
            .where('searchField', isLessThanOrEqualTo: '$search\uf8ff');
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Map<String, dynamic>> items = querySnapshot.docs.map((doc) {
        return {
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        };
      }).toList();
      items.add({'docRef': querySnapshot.docs.last});
      return items;
    } catch (e) {
      print('Error retrieving items: $e');
      return [];
    }
  }

  Future<bool> deleteItem(String itemId, String fotoUrl) async {
    try {
      if (fotoUrl.isNotEmpty) {
        await _storage.refFromURL(fotoUrl).delete();
      }
      await _firestore.collection('items').doc(itemId).delete();
      return true; // Delete successful
    } catch (e) {
      print('Error deleting empleado: $e');
      return false; // Delete failed
    }
  }

  Future<Map<String, dynamic>> getItemById({required String itemId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('items').doc(itemId).get();
      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting item by id: $e');
      return {};
    }
  }

  Future<bool> updateItem(
      {required String idItem,
      required Map<String, dynamic> updatedData}) async {
    try {
      print(updatedData);
      if (updatedData['foto_nueva'].isNotEmpty) {
        // eliminamos foto anterior
        if (updatedData['foto'].toString().isNotEmpty) {
          await _storage.refFromURL(updatedData['foto']).delete();
        }
        //agregamos foto nueva
        final file = File(updatedData['foto_nueva']);
        final String fileName = '$idItem${p.extension(file.path)}';
        TaskSnapshot taskSnapshot = await _storage.ref('/items/$fileName').putFile(
            file,
            SettableMetadata(
                contentType:
                    'image/${p.extension(file.path).toString().replaceAll('.', '')}'));
        updatedData['foto'] = await taskSnapshot.ref.getDownloadURL();
      }
      updatedData.remove('foto_nueva');
      updatedData.addAll(
          {'searchField': updatedData['nombre'].toString().toLowerCase()});
      await _firestore
          .collection('items')
          .doc(idItem)
          .update(updatedData); // elimino id para no repetir en la bd
      return true; // Update successful
    } catch (e) {
      print('Error updating item: $e');
      return false; // Update failed
    }
  }

  Future<void> putMockData() async {
    try {
      final data = await rootBundle.loadString('assets/MOCK_DATA_items.json');
      final List<dynamic> itemsList = jsonDecode(data);
      final List<Map<String, dynamic>> items =
          itemsList.cast<Map<String, dynamic>>();

      for (var item in items) {
        // Asigna un ID generado automáticamente
        await _firestore.collection('items').add(item);
      }
    } catch (e) {
      print('Error putting mock data: $e');
    }
  }

  Future<void> insensitiveCase() async {
    try {
      Query query = _firestore.collection('items');

      QuerySnapshot items = await query.get();

      for (var item in items.docs) {
        // Asigna un ID generado automáticamente
        await _firestore
            .collection('items')
            .doc(item.id)
            .update({'searchField': item['nombre'].toString().toLowerCase()});
      }
    } catch (e) {
      print('Error putting mock data: $e');
    }
  }
}
