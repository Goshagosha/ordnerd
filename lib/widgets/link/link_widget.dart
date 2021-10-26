import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_notekeeper/models/helpers/uritype.dart';
import 'package:student_notekeeper/models/link.dart';
import 'package:url_launcher/url_launcher.dart';

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
        if (widget.link.link.isNotEmpty)
          ListTile(
              title: Text(
                widget.link.link,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                String fullLink =
                    widget.link.uritype.protocol() + widget.link.link;
                canLaunch(fullLink).then((can) => can
                    ? launch(fullLink)
                    : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("The link can not be opened"))));
              },
              trailing: Icon(widget.link.uritype == URItype.http
                  ? Icons.link
                  : Icons.alternate_email)),
        if (widget.link.extra.isNotEmpty)
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
        if (widget.link.extra.isEmpty && widget.link.link.isEmpty)
          Center(child: Text("- - -"))
      ],
    );
  }
}
