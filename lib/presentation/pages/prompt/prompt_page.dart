import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/cron_core.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/custom_form_field.dart';
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
  double rangeValue = 0.5;

  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesState>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.runtimeType == TtsVoicesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return Card(
          color: DesignSystem.colors.secondary,
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                CustomFormField(
                  controller: controller,
                  hint: "Escreva o texto para ser pronunciado",
                ),

                const SizedBox(height: 16), // Espaço entre os Dropdowns
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                      child: CustomDropdown<TTsGoogleParamLanguage>(
                        list: tts.voicesBloc.state.voices.voices.keys.toList(),
                        hint: "Selecione uma voz",
                        bloc: langBloc,
                        onChanged: (value) => tts.voiceChoosenBloc.clear(),
                        map: (value) => DropdownMenuItem(value: value, child: Text(value.getLanguage())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: BlocBuilder<DropdownGenericBloc<TTsGoogleParamLanguage>, TTsGoogleParamLanguage?>(
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
                                  child: CustomDropdown<TtsVoiceCore>(
                                    list: list,
                                    hint: "Selecione uma voz",
                                    bloc: tts.voiceChoosenBloc,
                                    map: (value) => DropdownMenuItem(value: value, child: Text(value.name)),
                                  ));
                            });
                      }),
                ),
                const SizedBox(height: 16),
                const Text("Velocidade"),
                SizedBox(
                  width: 600,
                  child: Slider(
                    activeColor: DesignSystem.colors.primary,
                    value: rangeValue,
                    min: 0.0,
                    max: 1.0,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        rangeValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
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
          if (langBloc.state == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Escolha um idioma")));
            return;
          }

          if (tts.voiceChoosenBloc.state == null) {
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
