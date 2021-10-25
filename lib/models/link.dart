import 'package:student_notekeeper/models/helpers/uritype.dart';

class Link {
  String name;
  String type;
  URItype uritype;
  String? link;
  String? extra;

  Link(
      {required this.name,
      required this.type,
      this.uritype = URItype.http,
      this.link,
      this.extra});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'link': link,
      'uritype': uritype.index,
      'extra': extra
    }..removeWhere((key, value) => value == null);
  }

  static Link fromMap(Map m) {
    return Link(
        name: m['name'],
        type: m['type'],
        link: m.containsKey('link') ? m['link'] : null,
        uritype: m.containsKey('uritype') ? m['uritype'] : null,
        extra: m.containsKey('extra') ? m['extra'] : null);
  }
}
