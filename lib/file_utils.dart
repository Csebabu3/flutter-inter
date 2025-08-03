import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/$fileName';
}

Future<void> writeToFile(String fileName, String content) async {
  final path = await getFilePath(fileName);
  final file = File(path);
  await file.writeAsString(content);
}

Future<String> readFromFile(String fileName) async {
  final path = await getFilePath(fileName);
  final file = File(path);
  return await file.readAsString();
}
