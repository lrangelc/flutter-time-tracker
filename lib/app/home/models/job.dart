import 'package:meta/meta.dart';

class Job {
  String id;
  final String name;
  final int ratePerHour;

  Job({ this.id, @required this.name, this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
