import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> promptHistory = [
    {"prompt": "Olá, tudo bem?", "dateTime": DateTime.now().subtract(const Duration(hours: 1))},
    {"prompt": "Como você está?", "dateTime": DateTime.now().subtract(const Duration(hours: 2))},
    {"prompt": "O que você quer fazer?", "dateTime": DateTime.now().subtract(const Duration(hours: 3))},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promptHistory.length,
        itemBuilder: (context, index) {
          final item = promptHistory[index];
          final prompt = item["prompt"];
          final dateTime = item["dateTime"] as DateTime;

          return Column(
            children: [
              Card(
                color: DesignSystem.colors.secondary,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(prompt, style: TextStyle( color: DesignSystem.colors.textDetail),),
                  subtitle: Text(
                    "${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}",
                    style: TextStyle(color: DesignSystem.colors.textDetail),
                  ),
                  leading:  Icon(Icons.history, color: DesignSystem.colors.textDetail,),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16), // Espaço entre os Cards
            ],
          );
        },
      ),
    );
  }
}
