import 'dart:async';

import '../classes/classes.dart';
import '../providers/firebase/firestore_database.dart';

class FirestoreDatabaseRepository {
  final FirestoreDatabase firestoreDatabase;

  FirestoreDatabaseRepository({required this.firestoreDatabase});

  Stream<List<Profile>> streamProfiles({String? filter}) {
    StreamTransformer<List<Map<String, dynamic>>, List<Profile>> transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(
        data.map((e) => Profile.fromJson(e)).toList(),
      ),
    );

    return firestoreDatabase.streamProfiles(filter: filter).transform(transformer);
  }

  Stream<Profile> streamProfile({required String id}) {
    StreamTransformer<Map<String, dynamic>, Profile> transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(Profile.fromJson(data)),
    );

    return firestoreDatabase.streamProfile(id: id).transform(transformer);
  }

  Stream<List<Payment>> streamPayments({required String customerId}) {
    StreamTransformer<List<Map<String, dynamic>>, List<Payment>> transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(
        data.map((e) => Payment.fromJson(e)).toList(),
      ),
    );

    return firestoreDatabase
        .streamPayments(customerId: customerId)
        .transform(transformer);
  }

  Future<void> deleteProfile({required Profile profile}) async {
    await firestoreDatabase.deleteProfile(map: profile.toJson());
  }

  Future<void> setProfile({required Profile profile}) async {
    await firestoreDatabase.setProfile(
      map: profile.toJson(),
    );
  }

  Future<void> setPayment({required Payment payment}) async {
    await firestoreDatabase.setPayment(map: payment.toJson());
  }
}
