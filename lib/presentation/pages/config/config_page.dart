import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Configurações", style: TextStyle(color: DesignSystem.colors.textDetail))),
    );
  }
}
