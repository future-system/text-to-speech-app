import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_button.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';

import '../../../core/constants/tts_core_google_params_language.dart';
import '../../../core/tts_core_google.dart';
import '../../../core/voice_core.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  final TtsCoreGoogle tts = TtsCoreGoogle("AIzaSyCVOtglUcy3xRxk-x1qI2m8e-JmJ_RZZJU");
  final TextEditingController controller = TextEditingController(text: "Olá, tudo bem?");

  final DropdownGenericBloc<TTsGoogleParamLanguage> langBloc = DropdownGenericBloc<TTsGoogleParamLanguage>();

  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesState>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.runtimeType == TtsVoicesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            SizedBox(
              height: 50,
              child: DropdownButtonDefault<TTsGoogleParamLanguage>(
                list: tts.voicesBloc.state.voices.voices.keys.toList(),
                bloc: langBloc,
                onChanged: (value) => tts.voiceChoosenBloc.clear(),
                map: (value) => DropdownMenuItem(value: value, child: Text(value.getLanguage())),
              ),
            ),
            BlocBuilder<DropdownGenericBloc<TTsGoogleParamLanguage>, TTsGoogleParamLanguage?>(
                bloc: langBloc,
                builder: (context, state) {
                  return BlocBuilder<DropdownGenericBloc<TtsVoiceCore>, TtsVoiceCore?>(
                      bloc: tts.voiceChoosenBloc,
                      builder: (context, state) {
                        final List<TtsVoiceCore> list = tts.voicesBloc.state.voices.voices[langBloc.state] ?? [];
                        if (langBloc.state == null || list.isEmpty) {
                          return const SizedBox();
                        }

                        return SizedBox(
                            height: 50,
                            child: DropdownButtonDefault<TtsVoiceCore>(
                              list: list,
                              bloc: tts.voiceChoosenBloc,
                              map: (value) => DropdownMenuItem(value: value, child: Text(value.name)),
                            ));
                      });
                }),
            TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Escreva um texto a ser falado',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(langBloc.state == null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Escolha um idioma")));
            return;
          }

          if(tts.voiceChoosenBloc.state == null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Escolha uma voz")));
            return;
          }



          tts.talk(controller.text);
        },
        child: const Icon(Icons.volume_up),
      ),
      body: body(),
    );
  }
}
