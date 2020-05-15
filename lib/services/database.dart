import 'package:flutter_time_tracker/app/home/models/entry.dart';
import 'package:meta/meta.dart';

import 'package:flutter_time_tracker/services/firestore_service.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Future<void> createJob2(Job job);
  Future<void> updateJob(Job job);
  Future<void> deleteJob(Job job);
  Future<void> deleteJob2(Job job);
  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream({@required String jobId});

  Future<void> createEntry(Entry entry);
  Future<void> updateEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  @override
  Future<void> createJob(Job job) async => await _service.setData(
      path: APIPath.job(uid, documentIdFromCurrentDate()), data: job.toMap());

  @override
  Future<void> createJob2(Job job) async =>
      await _service.setData2(path: APIPath.jobs(uid), data: job.toMap());

  @override
  Future<void> updateJob(Job job) async => await _service.updateData(
      path: APIPath.job(uid, job.id), data: job.toMap());

  @override
  Future<void> deleteJob(Job job) async =>
      await _service.deleteData(path: APIPath.job(uid, job.id));

  @override
  Future<void> deleteJob2(Job job) async =>
      await _service.deleteData2(path: APIPath.job(uid, job.id));

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
      path: APIPath.job(uid, jobId),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> createEntry(Entry entry) async => await _service.setData2(
        path: APIPath.entries(uid),
        data: entry.toMap(),
      );

  @override
  Future<void> updateEntry(Entry entry) async => await _service.updateData(
      path: APIPath.entry(uid, entry.id), data: entry.toMap());

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData2(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  // Stream<List<Job>> jobsStream() {
  //   final path = APIPath.jobs(uid);
  //   final reference = Firestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((event) => event.documents
  //       .map(
  //         (snapshot) => Job.fromMap(snapshot.data),
  //       )
  //       .toList());
  // }

}
