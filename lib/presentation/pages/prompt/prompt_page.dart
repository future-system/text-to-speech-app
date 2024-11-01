import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/custom_form_field.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_button.dart';

import '../../../core/tts_core_google.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  final TtsCoreGoogle tts = initTts("AIzaSyCVOtglUcy3xRxk-x1qI2m8e-JmJ_RZZJU");
  final TextEditingController controller = TextEditingController();
  double rangeValue = 0.5;

  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesEvent>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.voices == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Flexible(
          flex: 1,
          child: Card(
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
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: CustomDropdown<VoiceGoogle>(
                            hint: "Selecione uma voz",
                            list: tts.voicesBloc.state.voices!.voices,
                            bloc: tts.voiceChoosenBloc,
                            map: (value) => DropdownMenuItem(
                              value: value,
                              child: Text('${value.name}'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Espaço entre os Dropdowns
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: CustomDropdown<VoiceGoogle>(
                            hint: "Selecione uma línguia",
                            list: tts.voicesBloc.state.voices!.voices,
                            bloc: tts.voiceChoosenBloc,
                            map: (value) => DropdownMenuItem(
                              value: value,
                              child: Text('${value.locale.name} - ${value.locale.code}'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Velocidade"),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tts.talk(controller.value.text);
        },
        child: const Icon(Icons.volume_up),
      ),
      body: body(),
    );
  }
}
