import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData(
      {@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    data['createdAt'] = FieldValue.serverTimestamp();
    data['statusId'] = 1;
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> setData2(
      {@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path).document();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['statusId'] = 1;
    print('reference: ${reference.documentID} $path: $data');
    await reference.setData(data);
  }

  Future<void> updateData(
      {@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    data['updatedAt'] = FieldValue.serverTimestamp();
    print('$path: $data');
    await reference.updateData(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  Future<void> deleteData2({@required String path}) async {
    Map<String, dynamic> data = {
      'deletedAt': FieldValue.serverTimestamp(),
      'statusId': 2
    };
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.updateData(data);
  }

  Stream<List<T>> collectionStream<T>(
      {@required String path,
      @required T builder(Map<String, dynamic> data, String documentId)}) {
    final reference =
        Firestore.instance.collection(path).where('statusId', isEqualTo: 1);
    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }
}
