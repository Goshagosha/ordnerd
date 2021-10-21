import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_notekeeper/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Link {
  String name;
  String type;
  String link;
  URItype uritype;
  int? dbId;

  Link(this.name, this.type,
      {this.link = '', this.dbId, this.uritype = URItype.http});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'link': link,
      'id': dbId,
      'uritype': uritype.index
    };
  }
}

class LinkWidget extends StatelessWidget {
  final Link link;

  const LinkWidget({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(link.name),
        subtitle: Text(link.type),
        onTap: () {
          if (link.link != '') {
            canLaunch(link.uritype.protocol() + link.link).then((value) {
              if (value) {
                launch(link.uritype.protocol() + link.link);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("The link can not be opened")));
              }
            });
          }
        },
        onLongPress: () {
          String content = link.link == '' ? link.name : link.link;
          Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(content + " copied to clipboard")));
        },
        trailing: Icon(
          Icons.link,
          color: (link.link != '')
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ));
  }
}
