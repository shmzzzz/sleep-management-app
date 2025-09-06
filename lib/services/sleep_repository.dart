import 'package:cloud_firestore/cloud_firestore.dart';

class SleepRepository {
  const SleepRepository();

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    final path = 'users/$uid/data';
    return FirebaseFirestore.instance.collection(path);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String uid) {
    return _collection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> add(String uid, Map<String, dynamic> entry) {
    final data = <String, dynamic>{
      ...entry,
      'createdAt': entry['createdAt'] ?? Timestamp.now(),
    };
    return _collection(uid).add(data);
  }

  Future<void> update(String uid, String documentId, Map<String, dynamic> entry) {
    return _collection(uid).doc(documentId).update(entry);
  }

  Future<void> delete(String uid, String documentId) {
    return _collection(uid).doc(documentId).delete();
  }
}

