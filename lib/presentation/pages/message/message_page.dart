import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/core.dart';
import 'package:text_to_speech_flutter/core/tts_bloc.dart';
import 'package:text_to_speech_flutter/presentation/components/custom_tab_bar.dart';
import 'package:text_to_speech_flutter/presentation/components/date_component.dart';
import 'package:text_to_speech_flutter/presentation/components/hour_component.dart';
import 'package:text_to_speech_flutter/presentation/components/week_component.dart';

import '../../../core/constants/tts_core_google_params_language.dart';
import '../../../core/voice_core.dart';
import '../../components/custom_bloc_form_field.dart';
import '../../components/custom_date_range_picker.dart';
import '../../components/custom_form_field.dart';
import '../../components/dropdown_button.dart';
import '../../components/dropdown_generic_bloc.dart';
import '../../components/text_value_object.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController controller = TextEditingController(text: "Olá, tudo bem?");

  final DropdownGenericBloc<TTsGoogleParamLanguage> langBloc = DropdownGenericBloc<TTsGoogleParamLanguage>();
  final CustomDateRangePicker dateRangePicker = CustomDateRangePicker();
  late final CustomBlocFormField<int> minuteBloc = CustomBlocFormField<int>(list: [for (var i = 0; i < 60; i += 1) i], hint: "Minutos", map: map);
  late final CustomBlocFormField<int> hourBloc = CustomBlocFormField<int>(list: [for (var i = 0; i < 24; i += 1) i], hint: "Horas", map: map);
  late final CustomBlocFormField<int> dayBloc = CustomBlocFormField<int>(list: [for (var i = 1; i < 32; i += 1) i], hint: "Dias", map: map);
  late final CustomBlocFormField<TextValueObject<int>> monthBloc = CustomBlocFormField<TextValueObject<int>>(list: [
    TextValueObject("Domingo", DateTime.sunday),
    TextValueObject("Segunda-feira", DateTime.monday),
    TextValueObject("Terça-feira", DateTime.tuesday),
    TextValueObject("Quarta-feira", DateTime.wednesday),
    TextValueObject("Quinta-feira", DateTime.thursday),
    TextValueObject("Sexta-feira", DateTime.friday),
    TextValueObject("Sábado", DateTime.saturday),
  ], hint: "Semanas", map: mapTextValueObject<int>);

  DropdownMenuItem<int> map(int value) {
    return DropdownMenuItem(value: value, child: Text(value.toString()));
  }

  DropdownMenuItem<TextValueObject<T>> mapTextValueObject<T>(TextValueObject<T> value) {
    return DropdownMenuItem(value: value, child: Text(value.text));
  }

  Widget body() {
    return BlocBuilder<TtsVoicesBloc, TtsVoicesState>(
      bloc: tts.voicesBloc,
      builder: (context, state) {
        if (state.runtimeType == TtsVoicesLoadingState) {
          return Center(
              child: CircularProgressIndicator(
            color: DesignSystem.colors.textDetail,
          ));
        }

        return Card(
          color: DesignSystem.colors.secondary,
          margin: const EdgeInsets.all(8),
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
                CustomTabBar(
                  tabs: const [
                    Tab(
                      text: "Data",
                      icon: Icon(Icons.calendar_today),
                    ),
                    Tab(
                      text: "Semana",
                      icon: Icon(Icons.calendar_today),
                    ),
                  ],
                  children: [
                    DateComponent(),
                    WeekComponent(),
                  ],
                ),
                const SizedBox(height: 10),
                HourComponent(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: DesignSystem.colors.secondary,
            onPressed: () {
              if (langBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Center(child: Text("Escolha um idioma")),
                  backgroundColor: DesignSystem.colors.error,
                ));
                return;
              }

              if (tts.voiceChoosenBloc.state == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Center(child: Text("Escolha uma voz")),
                  backgroundColor: DesignSystem.colors.error,
                ));
                return;
              }

              tts.cron(controller.text);
            },
            child: Icon(Icons.download, color: DesignSystem.colors.textDetail),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: DesignSystem.colors.secondary,
            onPressed: () {
              tts.talk(controller.text);
            },
            child: Icon(
              Icons.volume_up,
              color: DesignSystem.colors.textDetail,
            ),
          ),
        ],
      ),
      body: body(),
    );
  }
}
