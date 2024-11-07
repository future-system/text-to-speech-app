import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:text_to_speech_flutter/presentation/components/text_value_object.dart';

import 'dropdown_generic_bloc.dart';

class WeekComponent extends StatelessWidget {
  final DropdownGenericBloc<List<TextValueObject>> _langBloc = DropdownGenericBloc<List<TextValueObject>>();

  WeekComponent({super.key});

  List<TextValueObject> allWeekDays() => [
    TextValueObject("Domingo", 0),
    TextValueObject("Segunda-feira", 1),
    TextValueObject("Terça-feira", 2),
    TextValueObject("Quarta-feira", 3),
    TextValueObject("Quinta-feira", 4),
    TextValueObject("Sexta-feira", 5),
    TextValueObject("Sábado", 6),
  ];

  List<TextValueObject> get selectedDays => _langBloc.state ?? [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownGenericBloc<List<TextValueObject>>, List<TextValueObject>?>(
      bloc: _langBloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: MultiSelectDialogField<TextValueObject>(
            cancelText: const Text("Cancelar"),
            confirmText: const Text("Confirmar"),
            buttonText: const Text("Selecione os dias da semana"),
            initialValue: const [],
            searchHint: "Pesquise",
            title: const Text("Selecione os dias da semana"),
            selectedColor: Colors.green.shade200,
            unselectedColor: Colors.white70,
            selectedItemsTextStyle: const TextStyle(color: Colors.black),
            checkColor: Colors.white,
            backgroundColor: Colors.white,
            barrierColor: Colors.black.withOpacity(0.7),
            itemsTextStyle: const TextStyle(color: Colors.black),
            items: allWeekDays().map((e) => MultiSelectItem(e, e.text)).toList(),
            listType: MultiSelectListType.LIST,
            onConfirm: (values) {
              _langBloc.choose(values);
            },
          ),
        );
      },
    );
  }
}
