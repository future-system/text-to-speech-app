import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

import '../../core/tts_bloc.dart';
import 'dropdown_generic_bloc.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> list;
  final DropdownGenericBloc<T> bloc;
  final DropdownMenuItem<T> Function(T value) map;
  final String? hint;

  const CustomDropdown({
    required this.list,
    required this.map,
    required this.bloc,
    this.hint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownGenericBloc<T>, T?>(
      bloc: bloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: DesignSystem.colors.primary),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T?>(
              value: state,
              hint: Text(
                hint ?? "Selecione uma opção",
                style: TextStyle(color: DesignSystem.colors.primary),
              ),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: DesignSystem.colors.primary),
              onChanged: (T? value) {
                if (value != null) {
                  bloc.choose(value);
                }
              },
              items: list.map<DropdownMenuItem<T>>(map).toList(),
            ),
          ),
        );
      },
    );
  }
}
