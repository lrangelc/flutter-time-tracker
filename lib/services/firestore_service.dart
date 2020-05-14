import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    data['createdAt'] = FieldValue.serverTimestamp();
    data['statusId'] = 1;
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> setData2({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path).document();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['statusId'] = 1;
    print('reference: ${reference.documentID} $path: $data');
    await reference.setData(data);
  }

  Future<void> updateData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    data['updatedAt'] = FieldValue.serverTimestamp();
    print('$path: $data');
    await reference.updateData(data);
  }

  Stream<List<T>> collectionStream<T>(
      {@required String path,
      @required T builder(Map<String, dynamic> data, String documentId)}) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }
}
