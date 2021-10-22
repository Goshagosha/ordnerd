import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_notekeeper/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Link {
  String name;
  String type;
  String link;
  String extra;
  URItype uritype;
  int? dbId;

  Link(this.name, this.type,
      {this.link = '',
      this.dbId,
      this.uritype = URItype.http,
      this.extra = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'link': link,
      'id': dbId,
      'uritype': uritype.index,
      'extra': extra
    };
  }
}

class LinkWidget extends StatefulWidget {
  final Link link;

  const LinkWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.link.name),
      subtitle: Text(
        widget.link.type,
        style: Theme.of(context).textTheme.caption,
      ),
      children: [
        if (widget.link.link != '')
          ListTile(
              title: Text(
                widget.link.link,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                canLaunch(widget.link.uritype.protocol() + widget.link.link)
                    .then((value) {
                  if (value) {
                    launch(widget.link.uritype.protocol() + widget.link.link);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("The link can not be opened")));
                  }
                });
              },
              trailing: Icon(widget.link.uritype == URItype.http
                  ? Icons.link
                  : Icons.alternate_email)),
        if (widget.link.extra != '')
          InkWell(
            child: ListTile(
                title: Text(
                  widget.link.extra,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.link.extra));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${widget.link.extra} copied to the clipboard")));
                },
                trailing: const Icon(
                  Icons.short_text,
                )),
          ),
      ],
    );
  }
}
