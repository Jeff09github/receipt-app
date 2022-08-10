import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  static FirestoreDatabase get instance => FirestoreDatabase();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamProfiles({String? filter}) {
    StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<Map<String, dynamic>>> transform = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        final newData = data.docs.map((e) => e.data()).toList();
        sink.add(newData);
      },
    );

    return _firebaseFirestore
        .collection('profiles')
        .where('customerName', isGreaterThanOrEqualTo: filter)
        .where('customerName', isLessThan: filter != null ? '${filter}z' : null)
        .snapshots()
        .transform(transform);
    // return _firebaseFirestore
    //     .collection('profiles')
    //     .snapshots()
    //     .transform(transform);
  }

  Stream<Map<String, dynamic>> streamProfile({required String id}) {
    StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
        Map<String, dynamic>> transform = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        final newData = data.data();
        sink.add(newData!);
      },
    );
    return _firebaseFirestore
        .collection('profiles')
        .doc(id)
        .snapshots()
        .transform(transform);
  }

  Stream<List<Map<String, dynamic>>> streamPayments(
      {required String customerId}) {
    final paymentsRef = _firebaseFirestore.collection('payments');
    final query = paymentsRef.where('customerId', isEqualTo: customerId);

    StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<Map<String, dynamic>>> transform = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        final newData = data.docs.map((e) => e.data()).toList();
        sink.add(newData);
      },
    );
    return query.snapshots().transform(transform);
  }

  Future<void> setProfile({required Map<String, dynamic> map}) async {
    final ref = _firebaseFirestore.collection('profiles').doc(map['id']);
    await ref.set(map, SetOptions(merge: true));
  }

  Future<void> deleteProfile({required Map<String, dynamic> map}) async {
    await _firebaseFirestore.collection('profiles').doc(map['id']).delete();
  }

  Future<void> setPayment({required Map<String, dynamic> map}) async {
    await _firebaseFirestore.collection('payments').doc(map['id']).set(
          map,
          SetOptions(merge: true),
        );
  }
}
