import 'dart:convert';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:text_to_speech_flutter/core/PlayerCore.dart';
import 'package:text_to_speech_flutter/core/constants/util_file.dart';
import 'package:text_to_speech_flutter/core/constants/util_recorded.dart';

//https://en.wikipedia.org/wiki/Cron (Sim, eu peguei a documentação o wikipedia)
// # * * * * * <command to execute>
// # | | | | |
// # | | | | day of the week (0–6) (Sunday to Saturday;
// # | | | month (1–12)             7 is also Sunday on some systems)
// # | | day of the month (1–31)
// # | hour (0–23)
// # minute (0–59)

class CronCore {
  // {
  // "crons": [
  // {
  // "schedule": "* * * * *",
  // "seconds": 0, //Can be one of `int`, `List<int>` or `String` or `null` (= match all).
  // "minutes": 0,
  // "hours": 0,
  // "days": 0,
  // "weekdays": 0,
  // "months": 0,
  // "file": "file.mp3"
  // }
  // ]
  // }

  final _cron = Cron();
  final _player = PlayerCore();

  void schedule(String schedule, Function() function) {
    _cron.schedule(Schedule.parse(schedule), function);
  }

  void load() async {
    // load from json file called crons.json
    final Map<String, dynamic> crons = jsonDecode(File(await directoryCronPath()).readAsStringSync());

    for (final cron in crons["crons"]) {
      schedule(cron["schedule"], () async {
        final file = File(await directoryRecordedPath() + cron["file"]);

        if (file.existsSync()) {
          _player.playScrComplete(file.path);
        } else {
          print("File not found: ${file.path}");
        }
      });
    }
  }

  void save() {}

  Future<String> directoryCronPath() async {
    return directoryPath("cron");
  }
}
