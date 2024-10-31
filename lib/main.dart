import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/navigation.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: DesignSystem.colors.primary,
      theme: ThemeData(
          // fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          primaryColor: DesignSystem.colors.primary,
          colorScheme:
          ColorScheme.fromSeed(seedColor: DesignSystem.colors.primary),
          scaffoldBackgroundColor: DesignSystem.colors.background,
          textTheme: const TextTheme().apply(
            bodyColor: DesignSystem.colors.textDetail,
            displayColor: DesignSystem.colors.textDetail,
          )),
      routes: Navigation.routing.routes,
      initialRoute: Navigation.routing.home,
    );
  }
}
