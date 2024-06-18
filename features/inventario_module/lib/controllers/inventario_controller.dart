import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventario_module/models/item_model.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ItemsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Item>> getItems(
      {Map<String, dynamic> filters = const {
        'limit': 20,
        'search': '',
        'lastDocument': null
      }}) async {
    try {
      String search = filters['search'] ?? '';
      int limit = filters['limit'] ?? 20;

      Query query = _firestore.collection('items').limit(limit);
      if (filters['lastDocument'] != null) {
        DocumentSnapshot doc = await _firestore
            .collection('items')
            .doc(filters['lastDocument'])
            .get();
        query = query.startAfterDocument(doc);
      }
      if (search.isNotEmpty) {
        query = query
            .where('searchField', isGreaterThanOrEqualTo: search)
            .where('searchField', isLessThanOrEqualTo: '$search\uf8ff');
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Item> items = querySnapshot.docs
          .map((doc) => Item.fromFirestoreJson(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      if (items.isEmpty) {
        return List.empty();
      }
      //  items.add({'docRef': querySnapshot.docs.last});
      return items;
    } catch (e) {
      debugPrint('Error retrieving items: $e');
      return [];
    }
  }

  Future<bool> deleteItem(String itemId, String fotoUrl) async {
    try {
      if (fotoUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(fotoUrl).delete();
        } catch (e) {
          debugPrint('Error deleting photo: $e');
          // Continuar aunque haya fallado la eliminación de la foto
        }
      }

      await _firestore.collection('items').doc(itemId).delete();
      return true; // Delete successful
    } catch (e) {
      debugPrint('Error deleting item: $e');
      return false; // Delete failed
    }
  }

  Future<String> addItem({required Item newItem}) async {
    try {
      var idItemBd = const Uuid().v4(); // generamos id para el item
      if (newItem.foto.isNotEmpty) {
        newItem.foto = await uploadPhoto(
            File(newItem.foto), idItemBd); // subimos nueva foto con id generado
      }
      await _firestore.collection('items').doc(idItemBd).set(
          newItem.toJsonBD()); // elimino id para no poner ese campo en la bd
      return idItemBd;
    } catch (e) {
      debugPrint('Error adding empleado: $e');
      return '';
    }
  }

  Future<Item> getItemById({required String itemId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('items').doc(itemId).get();
      return Item.fromFirestoreJson(
          documentSnapshot.id, documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting item by id: $e');
      return Item.empty();
    }
  }

  Future<String> uploadPhoto(File file, String idItem) async {
    try {
      final String fileName = '$idItem${p.extension(file.path)}';
      TaskSnapshot taskSnapshot = await _storage.ref('/items/$fileName').putFile(
          file,
          SettableMetadata(
              contentType:
                  'image/${p.extension(file.path).toString().replaceAll('.', '')}'));
      return taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading photo: $e');
      return '';
    }
  }

  Future<bool> updateItem(
      {required Item updatedItem, required String newFoto}) async {
    try {
      if (newFoto.isNotEmpty) {
        // eliminamos foto anterior

        if (updatedItem.foto.toString().isNotEmpty) {
          try {
            await _storage.refFromURL(updatedItem.foto).delete();
          } catch (e) {
            debugPrint('Error deleting photo: $e');
            // Continuar aunque haya fallado la eliminación de la foto
          }
        }

        updatedItem.foto = await uploadPhoto(
            File(newFoto), updatedItem.id); // subimos nueva foto
      }

      await _firestore.collection('items').doc(updatedItem.id).update(
          updatedItem.toJsonBD()); // elimino id para no repetir en la bd
      return true; // Update successful
    } catch (e) {
      debugPrint('Error updating item: $e');
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
      debugPrint('Error putting mock data: $e');
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
      debugPrint('Error putting mock data: $e');
    }
  }
}
