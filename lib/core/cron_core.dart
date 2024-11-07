import 'dart:convert';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:text_to_speech_flutter/core/PlayerCore.dart';
import 'package:text_to_speech_flutter/core/constants/util_file.dart';

//https://en.wikipedia.org/wiki/Cron (Sim, eu peguei a documentação o wikipedia)
// # * * * * * <command to execute>
// # | | | | |
// # | | | | day of the week (0–6) (Sunday to Saturday;
// # | | | month (1–12)             7 is also Sunday on some systems)
// # | | day of the month (1–31)
// # | hour (0–23)
// # minute (0–59)

class CronCore {
  Map<String, dynamic> _crons = {};
  final _cron = Cron();
  final _player = PlayerCore();

  CronCore() {
    load();
  }

  Map<String, dynamic> get crons => _crons["crons"];

  void schedule(String schedule, Function() function) {
    _cron.schedule(Schedule.parse(schedule), function);
  }

  Future<File> createFileIfNotExistsCronJson() async {
    final fileCron = File("${await directoryCronPath()}${fileSeparetor}crons.json");

    if (!fileCron.existsSync()) {
      fileCron.createSync(recursive: true);
      fileCron.writeAsStringSync('{"crons":[]}');
    }

    return fileCron;
  }

  void create(Schedule schedule, String file, {String? menssage}) async {
    final fileCron = await createFileIfNotExistsCronJson();
    _crons = jsonDecode(fileCron.readAsStringSync());

    _crons["crons"].add({
      "schedule": schedule.toCronString(),
      "seconds": schedule.seconds ?? [],
      "minutes": schedule.minutes ?? [],
      "hours": schedule.hours ?? [],
      "days": schedule.days ?? [],
      "weekdays": schedule.weekdays ?? [],
      "months": schedule.months ?? [],
      "file": file,
      "menssage": menssage ?? "?",
    });

    fileCron.writeAsStringSync(jsonEncode(_crons));
  }

  void remove(String file) async {
    final fileCron = await createFileIfNotExistsCronJson();
    _crons = jsonDecode(fileCron.readAsStringSync());

    _crons["crons"] = _crons["crons"].where((element) => element["file"] != file).toList();

    fileCron.writeAsStringSync(jsonEncode(_crons));
  }

  void removeAll() async {
    final fileCron = await createFileIfNotExistsCronJson();
    _crons = {"crons":[]};
    fileCron.writeAsStringSync(jsonEncode(_crons));
  }

  void update(Schedule schedule, String file, {String? menssage}){//TODO, Perigoso...
    remove(file);
    create(schedule, file, menssage: menssage);
  }

  void load() async {
    // load from json file called crons.json
    _crons = jsonDecode(((await createFileIfNotExistsCronJson()).readAsStringSync()));

    for (final cron in _crons["crons"]) {
      print("${cron["schedule"]}\n->${cron["file"]}");

      schedule(cron["schedule"], () async {
        final file = File(cron["file"]);

        if (file.existsSync()) {
          _player.playScr(file.path);
        } else {
          print("File not found: ${file.path}");
        }
      });
    }
  }

  Future<List<CronCoreData>> getCrons() async => ((jsonDecode(((await createFileIfNotExistsCronJson()).readAsStringSync()))?["crons"] ?? []) as List<dynamic>).map<CronCoreData>((e) => CronCoreData.fromMap(e)).toList();

  Future<String> directoryCronPath() async {
    return directoryPath("cron");
  }

  void close () => _cron.close();
}

class CronCoreData {
  final String schedule;
  final List<int> seconds;
  final List<int> minutes;
  final List<int> hours;
  final List<int> days;
  final List<int> months;
  final List<int> weekdays;
  final String file;
  final String menssage;

  factory CronCoreData.fromMap(Map<String, dynamic> e) {
    return CronCoreData(
      schedule: e["schedule"] ?? "",
      seconds: ((e["seconds"] ?? []) as List).cast<int>(),
      minutes: ((e["minutes"] ?? []) as List).cast<int>(),
      hours: ((e["hours"] ?? []) as List).cast<int>(),
      days: ((e["days"] ?? []) as List).cast<int>(),
      months: ((e["months"] ?? []) as List).cast<int>(),
      weekdays: ((e["weekdays"] ?? []) as List).cast<int>(),
      file: e["file"] ?? "",
      menssage: e["menssage"] ?? "",
    );
  }

  CronCoreData({
    required this.schedule,
    required this.seconds,
    required this.minutes,
    required this.hours,
    required this.days,
    required this.months,
    required this.weekdays,
    required this.file,
    required this.menssage,
  });

  @override
  String toString() {
    return "(seconds: $seconds, minutes: $minutes, hours: $hours, days: $days, months: $months, weekdays: $weekdays, file: $file, menssage: $menssage)";
  }
}
