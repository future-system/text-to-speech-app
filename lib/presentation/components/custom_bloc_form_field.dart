import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_button.dart';
import 'dropdown_generic_bloc.dart';

class CustomBlocFormField<T> extends StatelessWidget {
  final DropdownGenericBloc<T> _bloc = DropdownGenericBloc<T>();
  final String hint;
  final List<T> list;
  final DropdownMenuItem<T> Function(T value) map;
  final Function(T value)? onChanged;

  CustomBlocFormField({super.key, required this.hint, required this.list, required this.map, this.onChanged});

  T? get value => _bloc.state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownGenericBloc<T>, T?>(
      bloc: _bloc,
      builder: (context, state) {
        // if (_bloc.state == null) {
        //   return const SizedBox();
        // }

        return SizedBox(
            height: 50,
            child: CustomDropdown<T>(
              list: list,
              hint: hint,
              bloc: _bloc,
              map: map,
              onChanged: onChanged,
            ));
      },
    );
  }
}
