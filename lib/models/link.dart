import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_notekeeper/models/helpers/uritype.dart';

class Link {
  String name;
  String type;
  URItype uritype;
  String lecture;
  String? dbId;
  String? link;
  String? extra;

  Link(
      {required this.name,
      required this.type,
      required this.lecture,
      this.dbId,
      this.uritype = URItype.http,
      this.link,
      this.extra});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'link': link,
      'lecture': lecture,
      'uritype': uritype.index,
      'extra': extra
    }..removeWhere((key, value) => value == null);
  }

  static Link fromSnapshot(DocumentSnapshot m) {
    Map cast = m.data() as Map<String, dynamic>;
    return Link(
        name: cast['name'],
        type: cast['type'],
        link: cast.containsKey('link') ? cast['link'] : null,
        dbId: m.id,
        lecture: cast['lecture'],
        uritype: cast.containsKey('uritype') ? cast['uritype'] : null,
        extra: cast.containsKey('extra') ? cast['extra'] : null);
  }
}
