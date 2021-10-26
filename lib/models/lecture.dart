import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_notekeeper/models/helpers/linktype.dart';
import 'package:student_notekeeper/models/link.dart';

class Lecture {
  String name;
  String? dbId;
  String address;
  String tutoriumAddress;
  String customNotes;

  Map<String, Link> links = {
    for (String k in linkType) k: Link(name: '', type: k)
  };

  Lecture({
    this.name = '',
    this.dbId,
    this.address = '',
    this.tutoriumAddress = '',
    this.customNotes = '',
  });

  static Lecture fromSnapshot(DocumentSnapshot snap) {
    Map cast = snap.data() as Map<String, dynamic>;
    cast['dbId'] = snap.id;
    return fromMap(cast);
  }

  static Lecture fromMap(Map m) {
    Lecture l = Lecture(
        name: m['name'],
        dbId: m.containsKey('dbId') ? m['dbId'] : null,
        address: m['address'],
        tutoriumAddress: m['tutorium_address'],
        customNotes: m['custom_notes']);

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

  /// We need to override [hashCode] and [==] so that when lecture values are updated,
  /// the widget tree will recognize the change and update the LectureCard widgets
  /// in the LectureList.
  @override
  int get hashCode => toMap().hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Lecture) return false;
    return dbId == other.dbId;
  }

  // String toJson() {
  //   Map _r = toMap();
  //   _r['links'] = links.map((key, value) => MapEntry(key, value.toMap()));
  //   return json.encode(_r);
  // }
}
