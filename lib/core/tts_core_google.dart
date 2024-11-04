import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:cron/cron.dart';
import 'package:text_to_speech_flutter/core/constants/tts_core_google_params_language.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/core/voice_core.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';

import 'PlayerCore.dart';
import 'cron_core.dart';

TtsCoreGoogle? _ttsCoreGoogle;

TtsCoreGoogle initTts(String key) {
  _ttsCoreGoogle ??= TtsCoreGoogle(key);
  return _ttsCoreGoogle!;
}

class TtsCoreGoogle {
  static bool initialized = false;
  final PlayerCore player = PlayerCore();
  final TtsVoicesBloc voicesBloc = TtsVoicesBloc();
  final DropdownGenericBloc<TtsVoiceCore> voiceChoosenBloc = DropdownGenericBloc<TtsVoiceCore>();
  final CronCore _cron = CronCore();


  TtsCoreGoogle(String apiKey) {
    if (!initialized) TtsGoogle.init(apiKey: apiKey, withLogs: true);
    initialized = true;
    initVoices();
  }

  void initVoices() async {
    try {
      final voices = await getVoices();

      voicesBloc.setVoice(voices.voices);
    } catch (e) {
      voicesBloc.setError(e.toString());
    }
  }

  Future<VoicesSuccessGoogle> getVoices() async {
    return await TtsGoogle.getVoices();
  }

  // List<TtsVoiceCore> getVoicesByLanguage() {
  //   return voicesBloc.state.getVoicesByLanguage(langChoosenBloc.state!);
  // }
  //
  // TtsVoiceCore getVoicesByLanguageAndName() {
  //   return voicesBloc.state.getVoicesByLanguage(langChoosenBloc.state!).where((element) => element.name == nameChoosenBloc.state).first;//PODE DAR PAU
  // }

  Future<VoiceGoogle> getVoice() async {
    if (voiceChoosenBloc.state == null) {
      throw Exception("Voice not initialized");
    }

    return voiceChoosenBloc.state!.toVoiceGoogle();
  }

  void chooseVoice(TtsVoiceCore voice) async {
    voiceChoosenBloc.choose(voice);
  }

  Future<TtsParamsGoogle> createParamsToSpeech(String text, {
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    return TtsParamsGoogle(
      voice: await getVoice(),
      audioFormat: "MP3",
      text: text,
      rate: rate.getRate(),
      //optional
      pitch: pitch.getPitch(), //optional
    );
  }

  void talk(String text, {
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.fast,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    player.playBytes((await convertTts(await createParamsToSpeech(text, rate: rate, pitch: pitch))).audio.buffer.asUint8List());
  }

  Future<String> record(String text, {
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    final audioName = await player.saveAudio(_createAudioName(text), (await convertTts(await createParamsToSpeech(text, rate: rate, pitch: pitch))).audio.buffer.asUint8List());

    player.playScr(audioName);

    return audioName;
  }

  void cron(String text, {
    List<int>? seconds,
    List<int>? minutes,
    List<int>? hours,
    List<int>? days,
    List<int>? months,
    List<int>? weekdays,
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    _cron.create(Schedule(seconds: seconds, minutes: minutes, hours: hours, days: days, months: months, weekdays: weekdays),  await record(text, pitch: pitch, rate: rate), menssage: text);
  }

  Future<AudioSuccessGoogle> convertTts(TtsParamsGoogle ttsParams) async {
    return await TtsGoogle.convertTts(ttsParams);
  }

  Future<Uint8List> convertTtsToAudioBytes(TtsParamsGoogle ttsParams) async {
    return (await convertTts(ttsParams)).audio.buffer.asUint8List();
  }

  String _createAudioName(String text) {
    return "${text.toLowerCase().replaceAll(" ", "_").substring(0, min(30, text.length))}__${voiceChoosenBloc.state?.locale.code ?? "pt-BR"}.mp3";
  }
}

enum RateTtsCoreGoogle {
  slow,
  fast,
  rateDefault;

  getRate() {
    switch (this) {
      case RateTtsCoreGoogle.slow:
        return 'slow';
      case RateTtsCoreGoogle.fast:
        return 'fast';
      case RateTtsCoreGoogle.rateDefault:
        return 'default';
    }
  }
}

enum PitchTtsCoreGoogle {
  low,
  high,
  pitchDefault;

  getPitch() {
    switch (this) {
      case PitchTtsCoreGoogle.low:
        return 'low';
      case PitchTtsCoreGoogle.high:
        return 'high';
      case PitchTtsCoreGoogle.pitchDefault:
        return 'default';
    }
  }
}
