import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordnerd/models/helpers/linktype.dart';
import 'package:ordnerd/models/helpers/uritype.dart';
import 'package:ordnerd/models/link.dart';
import 'package:ordnerd/utils/utils.dart';
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
                            text: widget.link.link.isNotEmpty ? widget.link.link :
                                widget.link.name
                                );
                        tec.selection = TextSelection(
                            baseOffset: 0, extentOffset: tec.text.length);

                        @override
                        // ignore: unused_element
                        void dispose() {
                          tec.dispose();
                          super.dispose();
                        }

                          URItype uritype = widget.link.uritype;
                          /// This is a link editor dialog. It's wrapped in stateful builder so we can call SetState from it.
                          /// We want to call setState from it to reflect updates to the protocol selection dropdown.
                        return StatefulBuilder(builder: (context, setState) {
                          String text = widget.link.link.elseEmpty();
                          return SingleChildScrollView(
                            child: AlertDialog(
                              insetPadding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
                              title: Text(widget.link.type.toHumanReadable() + " URI"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    DropdownButton(
                                      itemHeight: 66,
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
                                        items: <DropdownMenuItem<URItype>>[ 
                                          for (URItype ut in URItype.values) DropdownMenuItem(
                                            child:
                                                Text(ut.protocol()),
                                            value: ut,
                                          ) 
                                        ]),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                          controller: tec, autofocus: true),
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
                                        text = tec.text.stripProtocols();
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
                  color: (widget.link.link.isNotEmpty)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),),


            IconButton(
                onPressed: () async {
                  String? result = await showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController tec = TextEditingController();
                        tec.text = widget.link.extra.elseEmpty();
                        tec.selection = TextSelection(
                            baseOffset: 0, extentOffset: tec.text.length);

                        @override
                        // ignore: unused_element
                        void dispose() {
                          tec.dispose();
                          super.dispose();
                        }

                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                              insetPadding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
                            title: const Text("Extra (e.g. room password)"),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: TextFormField(
                                  controller: tec, autofocus: true),
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
                                        .then((data) => 
                                          setState(() async { tec.text = data?.text ?? tec.text})
                                    );
                                  },
                                  icon: const Icon(Icons.paste)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(tec.text);
                                  },
                                  icon: const Icon(Icons.done)),
                            ],
                          );
                        });
                      });
                    setState(() {
                        widget.link.extra = result.elseEmpty();
                        if (widget.link.name.isEmpty && result.elseEmpty().isNotEmpty) showDialog(context: context, builder: (context) => AlertDialog(content: const Text("This note won't save unless you give it a name!"), actions: [TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("OK"))],));
                    });
                  },
                icon: Icon(
                  Icons.short_text,
                  color: (widget.link.extra.isNotEmpty)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),

                ),
          ],
        )
      ],
    );
  }
}
