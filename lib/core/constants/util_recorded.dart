import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:text_to_speech_flutter/core/constants/util_file.dart';

Future<String> directoryRecordedPath() async {
  return directoryPath("recorded");
}

Future<String> saveRecordedFile(String nameAudio, Uint8List audio) async {
  final file = File("${await directoryRecordedPath()}$nameAudio");
  await file.writeAsBytes(audio);
  return file.path;
}

Future<Uint8List> readRecordedFile(String path) async {
  return await File(path).readAsBytes();
}
