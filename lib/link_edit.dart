import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:student_notekeeper/constants.dart';
import 'package:student_notekeeper/link.dart';
import 'package:tuple/tuple.dart';

class LinkEditorWidget extends StatefulWidget {
  final Link link;
  const LinkEditorWidget({Key? key, required this.link}) : super(key: key);

  @override
  _LinkEditorWidgetState createState() => _LinkEditorWidgetState();
}

class _LinkEditorWidgetState extends State<LinkEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.link.name,
                decoration: InputDecoration(hintText: widget.link.type),
                onChanged: (text) => widget.link.name = text,
              ),
            ),
            IconButton(
                onPressed: () async {
                  Tuple2? tuple = await showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController tec = TextEditingController(
                            text: widget.link.link == ''
                                ? widget.link.name
                                : widget.link.link);
                        tec.selection = TextSelection(
                            baseOffset: 0, extentOffset: tec.text.length);

                        @override
                        void dispose() {
                          tec.dispose();
                          super.dispose();
                        }

                        return StatefulBuilder(builder: (context, setState) {
                          String text = widget.link.link;
                          URItype uritype = widget.link.uritype;
                          return SingleChildScrollView(
                            child: AlertDialog(
                              insetPadding: EdgeInsets.all(16.0),
                              title: Text(widget.link.type + " URI"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    DropdownButton(
                                        underline: Container(
                                          height: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        onChanged: (URItype? type) {
                                          setState(() {
                                            uritype = type!;
                                          });
                                        },
                                        value: uritype,
                                        items: [
                                          DropdownMenuItem(
                                            child:
                                                Text(URItype.http.protocol()),
                                            value: URItype.http,
                                          ),
                                          DropdownMenuItem(
                                            child:
                                                Text(URItype.email.protocol()),
                                            value: URItype.email,
                                          ),
                                        ]),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 30,
                                        child: TextFormField(
                                            controller: tec, autofocus: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(Icons.close)),
                                IconButton(
                                    onPressed: () async {
                                      Clipboard.getData(Clipboard.kTextPlain)
                                          .then((data) {
                                            if (data != null) {
                                            setState(() async { tec.text = data.text!;})
                                          }
                                      });
                                    },
                                    icon: const Icon(Icons.paste)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        text = tec.text
                                            .replaceAll("http://", '')
                                            .replaceAll("https://", '')
                                            .replaceAll("mailto:", '');
                                      });
                                      Navigator.of(context)
                                          .pop(Tuple2(uritype, text));
                                    },
                                    icon: const Icon(Icons.done)),
                              ],
                            ),
                          );
                        });
                      });
                  if (tuple != null) {
                    setState(() {
                      widget.link.uritype = tuple.item1;
                      widget.link.link = tuple.item2;
                    });
                  }
                },
                icon: Icon(
                  Icons.link,
                  color: (widget.link.link != "")
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
                key: Key(widget.link.type.toString())),
          ],
        )
      ],
    );
  }
}
