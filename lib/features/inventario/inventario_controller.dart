import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ItemsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        };
      }).toList();
      items.add({'docRef': querySnapshot.docs.last});
      return items;
    } catch (e) {
      print('Error retrieving items: $e');
      return [];
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
