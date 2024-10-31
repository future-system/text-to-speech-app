import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> directoryRecordedPath() async {
  var directory = await  getApplicationDocumentsDirectory();
  var directoryPath = directory.path;
  var file = Directory("$directoryPath\\records\\");

  if(!file.existsSync()){
    file.createSync(recursive: true);
  }

  return file.path;
}

Future<String> saveRecordedFile(Uint8List audio) async {
  final file = File("${await directoryRecordedPath()}teste.mp3");//todo
  await file.writeAsBytes(audio);
  return file.path;
}

Future<Uint8List> readRecordedFile(String path) async {
  return await File(path).readAsBytes();
}
