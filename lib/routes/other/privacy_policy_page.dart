import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10))),
          child: FutureBuilder(
              future: _loadHtmlFromAssets(),
              builder: (_, AsyncSnapshot<String> snap) {
                if (!snap.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Html(data: snap.data),
                  ),
                );
              })),
    );
  }
}

Future<String> _loadHtmlFromAssets() async {
  return await rootBundle.loadString('assets/docs/privacy_policy.html');
}
