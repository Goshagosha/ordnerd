import 'package:student_notekeeper/models/helpers/linktype.dart';
import 'package:student_notekeeper/models/helpers/uritype.dart';

class Link {
  String name;
  LinkType type;
  URItype uritype;
  int? dbId;
  String? link;
  String? extra;

  Link(this.name, this.type,
      {this.uritype = URItype.http, this.dbId, this.link, this.extra});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.index,
      'link': link,
      'id': dbId,
      'uritype': uritype.index,
      'extra': extra
    }..removeWhere((key, value) => value == null);
  }
}
