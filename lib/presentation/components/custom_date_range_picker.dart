import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:text_to_speech_flutter/presentation/components/dropdown_generic_bloc.dart';

import 'custom_bloc_form_field.dart';

class CustomDateRangePicker extends StatelessWidget {
  final DateRangePickerController controller = DateRangePickerController();
  final DropdownGenericBloc<List<DateTime>> _bloc = DropdownGenericBloc<List<DateTime>>();

  CustomDateRangePicker({super.key});

  List<DateTime> get selectedDates => _bloc.state ?? [];

  Widget blocBuilder(Widget Function(BuildContext, List<DateTime>) builder){
    return BlocBuilder<DropdownGenericBloc<List<DateTime>>, List<DateTime>?>(
      bloc: _bloc,
      builder: (context, state) {
        if(state == null) return const Center(child: Text("Sem dados", style: TextStyle(color: Colors.white)));

        return builder(context, state);
      },
    );
  }

  void show(BuildContext context) {
    showDialog(context: context, builder: (context) => this);
  }

  Widget button(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blueGrey,
      ),
      child: IconButton(
        onPressed: () {
          show(context);
        },
        icon: const Icon(Icons.calendar_today, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Selecione as datas"),
          IconButton(onPressed: Navigator.of(context).pop, icon: const Icon(Icons.close, color: Colors.red)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        IconButton(
            onPressed: () {
              _bloc.clear();
              controller.selectedDates = [];
            },
            icon: const Icon(Icons.cleaning_services, color: Colors.blueGrey)),
        IconButton(
            onPressed: () {
              if (controller.selectedDates != null) {
                _bloc.choose(controller.selectedDates!);
                Navigator.of(context).pop();
                return;
              }

              _bloc.clear();
            },
            icon: const Icon(Icons.check, color: Colors.green)),
      ],
      content: SizedBox(
        height: 300,
        width: 300,
        child: SfDateRangePicker(
          //nao consigo tirar as letras da semana
          controller: controller,
          backgroundColor: Colors.grey.shade200,
          view: DateRangePickerView.month,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            showTrailingAndLeadingDates: true,
            showWeekNumber: false,
            weekNumberStyle: DateRangePickerWeekNumberStyle(textStyle: TextStyle(fontSize: 20)),
            viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(fontSize: 20)),
          ),
          monthCellStyle: const DateRangePickerMonthCellStyle(),
          headerStyle: const DateRangePickerHeaderStyle(textStyle: TextStyle(fontSize: 20, letterSpacing: 5)),
          selectionShape: DateRangePickerSelectionShape.circle,
          selectionMode: DateRangePickerSelectionMode.multiple,
          toggleDaySelection: true,
          showNavigationArrow: true,
          allowViewNavigation: false,
          showTodayButton: true,
          showActionButtons: false,
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(const Duration(days: 90)),
        ),
      ),
    );
  }
}
