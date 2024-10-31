import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Prompt", style: TextStyle(color: DesignSystem.colors.textDetail))),
    );
  }
}
