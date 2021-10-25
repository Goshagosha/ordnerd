import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_notekeeper/models/link.dart';

class Lecture {
  String name;
  String? dbId;
  String? address;
  String? tutoriumAddress;
  String? customNotes;

  Map<String, Link> links = {};

  Lecture({
    this.name = '',
    this.dbId,
    this.address,
    this.tutoriumAddress,
    this.customNotes,
  });

  static Lecture fromSnapshot(DocumentSnapshot m) {
    Map cast = m.data() as Map<String, dynamic>;
    Lecture l = Lecture(
        name: cast['name'],
        dbId: m.id,
        address: cast.containsKey('address') ? cast['address'] : null,
        tutoriumAddress: cast.containsKey('tutoriumAddress')
            ? cast['tutoriumAddress']
            : null,
        customNotes:
            cast.containsKey('customNotes') ? cast['customNotes'] : null);

    l.links = (m['links'] as Map)
        .map((key, value) => MapEntry(key, Link.fromMap(value)));
    return l;
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'id': dbId,
      'address': address,
      'tutorium_address': tutoriumAddress,
      'custom_notes': customNotes,
      'links': links.map((key, value) => MapEntry(key, value.toMap()))
    }..removeWhere((key, value) => value == null);
  }

  // String toJson() {
  //   Map _r = toMap();
  //   _r['links'] = links.map((key, value) => MapEntry(key, value.toMap()));
  //   return json.encode(_r);
  // }
}
