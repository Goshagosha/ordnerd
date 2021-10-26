import 'package:student_notekeeper/models/helpers/uritype.dart';

class Link {
  String name;
  String type;
  URItype uritype;
  String link;
  String extra;

  Link(
      {required this.name,
      required this.type,
      this.uritype = URItype.http,
      this.link = '',
      this.extra = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'link': link,
      'uritype': uritype.index,
      'extra': extra
    };
  }

  static Link fromMap(Map m) {
    return Link(
        name: m['name'],
        type: m['type'],
        uritype: URItype.values[m['uritype']],
        link: m['link'],
        extra: m['extra']);
  }
}
