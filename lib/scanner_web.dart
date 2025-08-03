// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_view_registry.dart'; // Use the cross-platform view registration

class ScannerWebPage extends StatefulWidget {
  const ScannerWebPage({super.key});

  @override
  State<ScannerWebPage> createState() => _ScannerWebPageState();
}

class _ScannerWebPageState extends State<ScannerWebPage> {
  String scannedResult = 'Waiting for scan...';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _registerView();
      _initScanner();
    }
  }

  void _registerView() {
    registerViewFactory('reader', (int viewId) {
      final div = html.DivElement()
        ..id = 'reader'
        ..style.width = '100%'
        ..style.height = '100%';
      return div;
    });
  }

  void _initScanner() {
    final jsCode = '''
      (function() {
        if (!window.html5QrcodeScannerInitialized) {
          window.html5QrcodeScannerInitialized = true;
          const scanner = new Html5Qrcode("reader");
          scanner.start(
            { facingMode: "environment" },
            {
              fps: 10,
              qrbox: 250
            },
            function(decodedText, decodedResult) {
              window.dispatchEvent(new CustomEvent('barcodeScanned', { detail: decodedText }));
              scanner.stop();
            },
            function(errorMessage) {
              // Ignore errors
            }
          );
        }
      })();
    ''';

    js.context.callMethod('eval', [jsCode]);

    html.window.addEventListener('barcodeScanned', (event) {
      final html.CustomEvent e = event as html.CustomEvent;
      setState(() {
        scannedResult = 'Scanned: ${e.detail}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Web Barcode Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Scan a QR or Barcode below:'),
            const SizedBox(height: 20),
            SizedBox(
              width: 320,
              height: 320,
              child: const HtmlElementView(viewType: 'reader'),
            ),
            const SizedBox(height: 20),
            Text(scannedResult),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scannedResult = 'Waiting for scan...';
                });
                _initScanner();
              },
              child: const Text('Restart Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
