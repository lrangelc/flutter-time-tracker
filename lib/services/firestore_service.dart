import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> setData2({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path).document();
    print('reference: ${reference.documentID} $path: $data');
    await reference.setData(data);
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
