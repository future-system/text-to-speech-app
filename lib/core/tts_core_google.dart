import 'dart:typed_data';

import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:text_to_speech_flutter/core/constants/tts_core_google_params_language.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/core/voice_core.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';

import 'PlayerCore.dart';


TtsCoreGoogle? _ttsCoreGoogle;

TtsCoreGoogle initTts(String key){
  _ttsCoreGoogle ??= TtsCoreGoogle(key);
  return _ttsCoreGoogle!;
}

class TtsCoreGoogle {
  static bool initialized = false;
  final PlayerCore player = PlayerCore();
  final TtsVoicesBloc voicesBloc = TtsVoicesBloc();
  final DropdownGenericBloc<TtsVoiceCore> voiceChoosenBloc = DropdownGenericBloc<TtsVoiceCore>();

  TtsCoreGoogle(String apiKey) {
    if(!initialized) TtsGoogle.init(apiKey: apiKey, withLogs: true);
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

  Future<TtsParamsGoogle> createParamsToSpeech(
    String text, {
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
    TTsGoogleParamLanguage language = TTsGoogleParamLanguage.ptBR,
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

  void talk(
    String text, {
    TTsGoogleParamLanguage language = TTsGoogleParamLanguage.ptBR,
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.fast,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    player.playBytes((await convertTts(await createParamsToSpeech(text, rate: rate, pitch: pitch))).audio.buffer.asUint8List());
  }

  void record(
    String text, {
    TTsGoogleParamLanguage language = TTsGoogleParamLanguage.ptBR,
    RateTtsCoreGoogle rate = RateTtsCoreGoogle.slow,
    PitchTtsCoreGoogle pitch = PitchTtsCoreGoogle.pitchDefault,
  }) async {
    player.saveAudio((await convertTts(await createParamsToSpeech(text, rate: rate, pitch: pitch))).audio.buffer.asUint8List());

    player.playScr();
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
