import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Histórico", style: TextStyle(color: DesignSystem.colors.textDetail))),
    );
  }
}
