import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:student_notekeeper/models/lecture.dart';
import 'package:student_notekeeper/routes/lectures/lecture_edit.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const QRScannerPage());

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderLength: 32,
                  borderRadius: 0,
                  borderWidth: 16,
                  cutOutSize: scanArea),
              onQRViewCreated: (ctrl) => _onQRViewCreated(ctrl, context),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      Lecture scanned = Lecture.fromMap(jsonDecode(scanData.code) as Map)
        ..dbId = null;
      Navigator.of(context)
          .pushReplacement(LectureEditPage.route(lecture: scanned));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
