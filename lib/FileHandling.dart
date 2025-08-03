import 'package:flutter/material.dart';
import 'file_utils.dart';
import 'file_picker_page.dart';
import 'file_download_page.dart';
import 'file_upload_page.dart';

class FileHandling extends StatelessWidget {
  final String fileName = "my_file.txt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Handling in Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await writeToFile(fileName, "Hello from Flutter!");
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('File Written')));
              },
              child: Text("Write to File"),
            ),
            ElevatedButton(
              onPressed: () async {
                String content = await readFromFile(fileName);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("File Content"),
                    content: Text(content),
                  ),
                );
              },
              child: Text("Read from File"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FilePickerPage()),
                );
              },
              child: Text("Pick a File"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FileDownloadPage()),
                );
              },
              child: Text("Download File"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FileUploadPage()),
                );
              },
              child: Text("Upload File"),
            ),
          ],
        ),
      ),
    );
  }
}
