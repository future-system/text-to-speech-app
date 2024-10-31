import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/presentation/components/side_bar.dart';
import 'package:text_to_speech_flutter/presentation/pages/config/config_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/message/message_page.dart';
import 'package:text_to_speech_flutter/presentation/pages/prompt/prompt_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  static const List<Widget> _pages = <Widget>[
    PromptPage(),
    MessagePage(),
    HistoryPage(),
    ConfigPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedPage: _selectedPage,
            onItemTapped: _onItemTapped,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _pages[_selectedPage],
            ),
          ),
        ],
      ),
    );
  }
}