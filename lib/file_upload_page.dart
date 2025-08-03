import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class FileUploadPage extends StatelessWidget {
  final String uploadUrl = 'https://httpbin.org/post'; // Example URL

  Future<void> uploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload File')),
      body: Center(
        child: ElevatedButton(
          child: Text("Upload File"),
          onPressed: () => uploadFile(context),
        ),
      ),
    );
  }
}
