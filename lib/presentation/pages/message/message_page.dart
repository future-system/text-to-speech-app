import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Mensagem", style: TextStyle(color: DesignSystem.colors.textDetail))),
    );
  }
}
