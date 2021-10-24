import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:student_notekeeper/models/helpers/linktype.dart';
import 'package:student_notekeeper/models/link.dart';

class Lecture {
  String name;
  int? dbId;
  String? address;
  String? tutoriumAddress;
  String? customNotes;

  Map<LinkType, Link> links = {};

  Lecture(
    this.name, {
    this.dbId,
    this.address,
    this.tutoriumAddress,
    this.customNotes,
  });

  static Lecture fromSnapshot(DocumentSnapshot m) {
    Lecture l = Lecture(m['name'],
        dbId: m['id'],
        address: m['address'],
        tutoriumAddress: m['tutoriumAddress'],
        customNotes: m['customNotes']);
    Logger().d(l);
    l.links = Map.fromIterable((m['links'] as List),
        key: (eachLink) => ((eachLink as Map)['type'] as int).toLinkType());
    return l;
  }

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
