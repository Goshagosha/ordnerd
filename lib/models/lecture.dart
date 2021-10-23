import 'package:student_notekeeper/models/link.dart';

class Lecture {
  String name;
  int? dbId;
  String? address;
  String? tutoriumAddress;
  String? customNotes;

  Map<int, Link> links = {};

  Lecture(
    this.name, {
    this.dbId,
    this.address,
    this.tutoriumAddress,
    this.customNotes,
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'id': dbId,
      'address': address,
      'tutorium_address': tutoriumAddress,
      'custom_notes': customNotes
    }..removeWhere((key, value) => value == null);
  }

  // String toJson() {
  //   Map _r = toMap();
  //   _r['links'] = links.map((key, value) => MapEntry(key, value.toMap()));
  //   return json.encode(_r);
  // }
}
