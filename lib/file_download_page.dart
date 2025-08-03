import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'file_utils.dart';

class FileDownloadPage extends StatelessWidget {
  final String fileUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
  final String fileName = 'downloaded_dummy.pdf';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download File')),
      body: Center(
        child: ElevatedButton(
          child: Text("Download File"),
          onPressed: () async {
            final response = await http.get(Uri.parse(fileUrl));
            final path = await getFilePath(fileName);
            final file = File(path);
            await file.writeAsBytes(response.bodyBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File downloaded to $path')),
            );
          },
        ),
      ),
    );
  }
}
