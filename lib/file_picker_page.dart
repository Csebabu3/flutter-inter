import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick a File')),
      body: Center(
        child: ElevatedButton(
          child: Text("Pick File"),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              File file = File(result.files.single.path!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Picked File: ${file.path}')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No file selected')),
              );
            }
          },
        ),
      ),
    );
  }
}
