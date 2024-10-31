import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:text_to_speech_flutter/tts_api.dart';

class Tts extends StatefulWidget {
  const Tts({Key? key}) : super(key: key);

  @override
  _TtsState createState() => _TtsState();
}

class _TtsState extends State<Tts> {
  final player = AudioPlayer();

  @override
  void initState() {

    TtsGoogle.init(apiKey: "AIzaSyCVOtglUcy3xRxk-x1qI2m8e-JmJ_RZZJU", withLogs: true);

    super.initState();
  }

  Future<VoicesSuccessGoogle>  getVoices() async {
    return await TtsGoogle.getVoices();
  }

  Future<VoiceGoogle> getVoice() async{
    return (await getVoices()).voices.where((element) => element.locale.code.startsWith("pt-"))
        .toList(growable: false)
        .first;
  }

  void talk() async {
    final ttsParams = TtsParamsGoogle(
        voice: await getVoice(),
        audioFormat: "MP3",
        text: TEXTO_PEQUENO,
        rate: 'slow', //optional
        pitch: 'default' //optional
    );

    final ttsResponse = await TtsGoogle.convertTts(ttsParams);

    final audioBytes = ttsResponse.audio.buffer.asUint8List();

    if(audioBytes.lengthInBytes > 0){
      print("TEM AUDIO");
      print(audioBytes);
    }

    player.play(BytesSource(audioBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          talk();
        },
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}
