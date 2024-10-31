import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/presentation/pages/config/config_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/home/home_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/message/message_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/prompt/prompt_page.dart';

sealed class Navigation {
  static final routing = _Routing();
}

final class _Routing {
  Map<String, WidgetBuilder> get routes => {
    prompt: (context) => const PromptPage(),
    message: (context) => const MessagePage(),
    config: (context) => const ConfigPage(),
    history: (context) => const HistoryPage(),
    home: (context) => const HomePage(),
  };
  final String prompt = 'prompt';
  final String message = 'message';
  final String config = 'config';
  final String history = 'history';
  final String home = "home";
}
