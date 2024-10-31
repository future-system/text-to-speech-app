import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_button.dart';

import '../../../core/tts_core_google.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  final TtsCoreGoogle tts = TtsCoreGoogle("");
  final TextEditingController controller = TextEditingController(text: "Olá, tudo bem?");


  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesEvent>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.voices == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            SizedBox(
              height: 50,
              child: DropdownButtonExample<VoiceGoogle>(
                list: tts.voicesBloc.state.voices!.voices,
                bloc: tts.voiceChoosenBloc,
                map: (value) => DropdownMenuItem(value: value, child: Text('${value.name} - ${value.locale.name} - ${value.locale.code}')),
              ),
            ),
            TextFormField(
              controller: controller,
              style: TextStyle(color: Colors.white),
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tts.talk(controller.text);
        },
        child: const Icon(Icons.volume_up),
      ),
      body: body(),
    );
  }
}
