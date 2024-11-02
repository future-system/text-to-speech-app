import 'package:bloc/bloc.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:text_to_speech_flutter/core/voice_core.dart';

class TtsVoicesBloc extends Cubit<TtsVoicesState> {
  TtsVoicesBloc() : super(TtsVoicesLoadingState());

  void setVoice(List<VoiceGoogle> voices) => emit(TtsVoicesSuccessState(VoiceCore(voices: voices)));

  void setError(String message) => emit(TtsVoicesErrorState(message, VoiceCore.empty()));
}

//class TtsVoicesEvent{}

//class TtsVoicesLoadingEvent extends TtsVoicesEvent{}

class TtsVoicesState {
  final VoiceCore voices;

  TtsVoicesState(this.voices);
}

class TtsVoicesSuccessState extends TtsVoicesState {
  TtsVoicesSuccessState(super.voices);
}

class TtsVoicesLoadingState extends TtsVoicesState {
  TtsVoicesLoadingState() : super(VoiceCore.empty());
}

class TtsVoicesErrorState extends TtsVoicesState {
  final String message;

  TtsVoicesErrorState(this.message, super.voices);
}
