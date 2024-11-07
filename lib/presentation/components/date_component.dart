import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'dropdown_generic_bloc.dart';

class DateComponent extends StatelessWidget {
  final DropdownGenericBloc<List<int>> _langBloc = DropdownGenericBloc<List<int>>();

  DateComponent({super.key});

  List<int> allDays() => List.generate(31, (index) => index + 1);

  List<int> get selectedDays => _langBloc.state ?? [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownGenericBloc<List<int>>, List<int>?>(
      bloc: _langBloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: MultiSelectDialogField<int>(
            cancelText: const Text("Cancelar"),
            confirmText: const Text("Confirmar"),
            buttonText: const Text("Selecione os dias"),
            initialValue: const [],
            searchHint: "Pesquise",
            title: const Text("Selecione os dias"),
            selectedColor: Colors.green.shade200,
            unselectedColor: Colors.white70,
            selectedItemsTextStyle: const TextStyle(color: Colors.black),
            checkColor: Colors.white,
            backgroundColor: Colors.white,
            barrierColor: Colors.black.withOpacity(0.7),
            itemsTextStyle: const TextStyle(color: Colors.black),
            items: allDays().map((e) => MultiSelectItem(e, "$e")).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              _langBloc.choose(values);
            },
          ),
        );
      },
    );
  }
}
