import 'package:meta/meta.dart';

class Job {
  String id;
  final String name;
  final int ratePerHour;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int statusId;

  Job(
      {this.id,
      @required this.name,
      this.ratePerHour,
      this.createdAt,
      this.updatedAt,
      this.statusId});

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    final DateTime createdAt = data['createdAt']?.toDate() ?? null;
    final DateTime updatedAt = data['createdAt']?.toDate() ?? null;
    final int statusId = data['statusId'];
    return Job(
        id: documentId,
        name: name,
        ratePerHour: ratePerHour,
        createdAt: createdAt,
        updatedAt: updatedAt,
        statusId: statusId);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
