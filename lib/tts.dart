import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/tts_core_google.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:text_to_speech_flutter/tts_api.dart';

class Tts extends StatefulWidget {
  const Tts({super.key});

  @override
  _TtsState createState() => _TtsState();
}

class _TtsState extends State<Tts> {

  final TtsCoreGoogle tts = TtsCoreGoogle("AIzaSyCVOtglUcy3xRxk-x1qI2m8e-JmJ_RZZJU");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tts.talk("Olá, mundo!");
        },
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}
