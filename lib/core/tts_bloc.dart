import 'package:bloc/bloc.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';

class TtsVoiceBloc extends Cubit<VoiceGoogle?>{
  TtsVoiceBloc() : super(null);

  void chooseVoice(VoiceGoogle voice) => emit(voice);
}

class TtsVoicesBloc extends Cubit<TtsVoicesEvent>{
  TtsVoicesBloc() : super(TtsVoicesLoadingEvent());

  void setVoice(VoicesSuccessGoogle voices) => emit(TtsVoicesSuccessEvent(voices));

  void setError(String message) => emit(TtsVoicesErrorEvent(message, null));
}

class TtsVoicesEvent{
  final VoicesSuccessGoogle? voices;

  TtsVoicesEvent(this.voices);
}

class TtsVoicesSuccessEvent extends TtsVoicesEvent{
  TtsVoicesSuccessEvent(super.voices);
}

class TtsVoicesLoadingEvent extends TtsVoicesEvent{
  TtsVoicesLoadingEvent() : super(null);
}

class TtsVoicesErrorEvent extends TtsVoicesEvent{
  final String message;

  TtsVoicesErrorEvent(this.message, super.voices);
}

