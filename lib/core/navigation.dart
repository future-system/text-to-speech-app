import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_cubit.dart';
import 'package:text_to_speech_flutter/presentation/pages/home/home_page.dart';


sealed class Navigation {
  static final routing = _Routing();
}

final class _Routing {
  Map<String, WidgetBuilder> get routes => {
    home: (context) => BlocProvider<HistoryCubit>(
      child: const HomePage(),
      create: (BuildContext context) => HistoryCubit(),
    ),
  };

  final String home = "home";
}
