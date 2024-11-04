import 'dart:io';

import 'package:path_provider/path_provider.dart';

const String directoryDefaultPath = "tts\\";

String get fileSeparetor => Platform.pathSeparator;

Future<String> directoryPath(String path) async {
  var directory = await  getApplicationDocumentsDirectory();
  var directoryPath = directory.path;
  var file = Directory("$directoryPath$fileSeparetor$directoryDefaultPath$path$fileSeparetor");//TODO, isso só vai funcionar no windows

  if(!file.existsSync()){
    file.createSync(recursive: true);
  }

  return file.path;
}

Future<List<File>> getAllFilesUsingDirectoryPath(String path) async {
  var directory = await directoryPath(path);
  var dir = Directory(directory);
  return dir.listSync().map((e) => File(e.path)).toList();
}