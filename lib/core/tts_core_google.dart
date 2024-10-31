import 'dart:typed_data';

import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:text_to_speech_flutter/core/constants/tts_core_google_params_language.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';

import 'PlayerCore.dart';

class TtsCoreGoogle {
  final PlayerCore player = PlayerCore();
  final TtsVoicesBloc voicesBloc = TtsVoicesBloc();
  final DropdownGenericBloc<VoiceGoogle> voiceChoosenBloc = DropdownGenericBloc<VoiceGoogle>();


  TtsCoreGoogle(String apiKey) {
    TtsGoogle.init(apiKey: apiKey, withLogs: true);
    initVoices();
  }

  void initVoices() async {
    try {
      voicesBloc.setVoice(await getVoices());
    } catch (e) {
      voicesBloc.setError(e.toString());
    }
  }

  Future<VoicesSuccessGoogle> getVoices() async {
    return await TtsGoogle.getVoices();
  }

  Future<VoiceGoogle> getVoice(TTsGoogleParamLanguage language) async {
    if(voicesBloc.state.voices == null){
      throw Exception("Voices not initialized");
    }

    return (voicesBloc.state.voices!).voices.where((element) => element.locale.code == language.getLanguage()).toList(growable: false).first;
  }

  void chooseVoice(TTsGoogleParamLanguage language) async {
    voiceChoosenBloc.choose(await getVoice(language));
  }

  Future<TtsParamsGoogle> createParamsToSpeech(
    String text, {
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
    TTsGoogleParamLanguage language = TTsGoogleParamLanguage.ptBR,
  }) async {
    if(voiceChoosenBloc.state == null){
      throw Exception("Voice not initialized");
    }

    return TtsParamsGoogle(
      voice: voiceChoosenBloc.state!,
      audioFormat: "MP3",
      text: text,
      rate: rate.getRate(),
      //optional
      pitch: pitch.getPitch(), //optional
    );
  }

  void talk(
    String text, {
    TTsGoogleParamLanguage language = TTsGoogleParamLanguage.ptBR,
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    player.playBytes((await convertTts(await createParamsToSpeech(text, rate: rate, pitch: pitch))).audio.buffer.asUint8List());
  }

  Future<AudioSuccessGoogle> convertTts(TtsParamsGoogle ttsParams) async {
    return await TtsGoogle.convertTts(ttsParams);
  }

  Future<Uint8List> convertTtsToAudioBytes(TtsParamsGoogle ttsParams) async {
    return (await convertTts(ttsParams)).audio.buffer.asUint8List();
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
