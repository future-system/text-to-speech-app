import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/cron_core.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/data/models/history_model.dart';
import 'package:text_to_speech_flutter/presentation/components/custom_form_field.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_button.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_cubit.dart';

import '../../../core/constants/tts_core_google_params_language.dart';
import '../../../core/core.dart';
import '../../../core/tts_core_google.dart';
import '../../../core/voice_core.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  final TextEditingController controller = TextEditingController(text: "Olá, tudo bem?");

  final DropdownGenericBloc<TTsGoogleParamLanguage> langBloc = DropdownGenericBloc<TTsGoogleParamLanguage>();
  double rangeValue = 0.5;


  late final HistoryCubit historyCubit;

  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesState>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.runtimeType == TtsVoicesLoadingState) {
          return  Center(child: CircularProgressIndicator(color: DesignSystem.colors.textDetail,));
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
                const SizedBox(height: 16),
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
    historyCubit = context.read<HistoryCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: DesignSystem.colors.secondary,
            onPressed: () {
              if (langBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Center(child:  Text("Escolha um idioma")), backgroundColor: DesignSystem.colors.error,));
                return;
              }

              if (tts.voiceChoosenBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Center(child:  Text("Escolha uma voz")), backgroundColor: DesignSystem.colors.error,));
                return;
              }

              tts.record(controller.text);
            },
            child: Icon(Icons.download, color: DesignSystem.colors.textDetail),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: DesignSystem.colors.secondary,
            onPressed: () {
              if (langBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Center(child:  Text("Escolha um idioma")), backgroundColor: DesignSystem.colors.error,));
                return;
              }

              if (tts.voiceChoosenBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Center(child:  Text("Escolha uma voz")), backgroundColor: DesignSystem.colors.error,));
                return;
              }

              historyCubit.insert(HistoryModel(content: controller.text, date: DateTime.now()));

              tts.talk(controller.text);
            },
            child:  Icon(Icons.volume_up, color: DesignSystem.colors.textDetail,),
          ),
        ],
      ),
      body: body(),
    );
  }
}
