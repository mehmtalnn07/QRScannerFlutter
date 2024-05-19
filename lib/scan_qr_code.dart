import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String qrResult = 'Taradığınız Veriler Burada Görünecek';

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        qrResult = qrCode.toString();
      });
      if (await canLaunch(qrCode)) {
        await launch(qrCode);
      } else {
        setState(() {
          qrResult = 'Geçersiz URL';
        });
      }
    } on PlatformException {
      setState(() {
        qrResult = 'Kod okunurken bir hata oluştu';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Kod Tarama')),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              qrResult,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: scanQR,
                child: Text('QR Tara'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
