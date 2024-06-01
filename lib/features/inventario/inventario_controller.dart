import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> getItems(
      {Map<String, dynamic> filters = const {
        'limit': 20,
        'search': ''
      }}) async {
    try {
      String search = filters['search'] ?? '';
      int limit = filters['limit'] ?? 20;
      Query query = _firestore.collection('items').limit(limit);

      if (search.isNotEmpty) {
        query = query
            .where('nombre', isGreaterThanOrEqualTo: search)
            .where('nombre', isLessThanOrEqualTo: search + '\uf8ff');
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Map<String, dynamic>> items = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return items;
    } catch (e) {
      print('Error retrieving items: $e');
      return [];
    }
  }
}
