// lang - name
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';

import 'constants/tts_core_google_params_language.dart';

class VoiceCore {
  final Map<TTsGoogleParamLanguage, List<TtsVoiceCore>> voices = {};

  factory VoiceCore.empty() {
    return VoiceCore(voices: []);
  }

  VoiceCore({required List<VoiceGoogle> voices}) {
    try{
      for (final element in voices) {

        final TTsGoogleParamLanguage lang = TTsGoogleParamLanguage.getEnum(element.locale.code);

        if (this.voices[lang] == null) {
          this.voices[lang] = [];
        }

        this.voices[lang]?.add(
          TtsVoiceCore(
            code: element.code,
            voiceType: element.voiceType,
            name: element.name,
            gender: element.gender,
            locale: TtsVoiceLocale(
              code: element.locale.code,
              name: element.locale.name,
              nativeName: element.locale.nativeName,
              languageCode: element.locale.languageCode,
              languageName: element.locale.languageName,
              nativeLanguageName: element.locale.nativeLanguageName,
              countryCode: element.locale.countryCode,
              countryName: element.locale.countryName,
              nativeCountryName: element.locale.nativeCountryName,
              scriptCode: element.locale.scriptCode,
            ),
            nativeName: element.nativeName,
            sampleRateHertz: element.sampleRateHertz,
          ),
        );

      }
    } catch(e){
      print("Error: $e");
    }
  }

  List<TtsVoiceCore> getVoicesByLanguage(TTsGoogleParamLanguage lang) {
    return voices[lang] ?? [];
  }
}

class TtsVoiceCore {
  final String code;
  final String voiceType;
  final String name;
  final String nativeName;
  final String gender;
  final TtsVoiceLocale locale;
  final String sampleRateHertz;

  TtsVoiceCore({
    required this.code,
    required this.voiceType,
    required this.name,
    required this.nativeName,
    required this.gender,
    required this.locale,
    required this.sampleRateHertz,
  });

  VoiceGoogle toVoiceGoogle() {
    return VoiceGoogle(
      code: code,
      voiceType: voiceType,
      name: name,
      nativeName: nativeName,
      sampleRateHertz: sampleRateHertz,
      locale: locale.toVoiceLocale(),
      gender: gender,
    );
  }
}

class TtsVoiceLocale {
  String code;
  String? name;
  String? nativeName;
  String? languageCode;
  String? languageName;
  String? nativeLanguageName;
  String? countryCode;
  String? countryName;
  String? nativeCountryName;
  String? scriptCode;

  TtsVoiceLocale({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.languageCode,
    required this.languageName,
    required this.nativeLanguageName,
    required this.countryCode,
    required this.countryName,
    required this.nativeCountryName,
    required this.scriptCode,
  });

  VoiceLocale toVoiceLocale() {
    return VoiceLocale(
      code: code,
      name: name,
      nativeName: nativeName,
      languageCode: languageCode,
      languageName: languageName,
      nativeLanguageName: nativeLanguageName,
      countryCode: countryCode,
      countryName: countryName,
      nativeCountryName: nativeCountryName,
      scriptCode: scriptCode,
    );
  }
}
