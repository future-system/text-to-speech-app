import 'package:flutter/material.dart';

import '../../core/tts_bloc.dart';
import 'dropdown_generic_bloc.dart';

class DropdownButtonExample<T> extends StatelessWidget {
  final List<T> list;
  final DropdownGenericBloc<T> bloc;
  final DropdownMenuItem<T> Function(T value) map;

  DropdownButtonExample({required this.list, required this.map, required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T?>(
      value: bloc.state,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (T? value) {
        if (value != null) {
          bloc.choose(value);
        }
      },
      items: list.map<DropdownMenuItem<T>>(map).toList(),
    );
  }
}
