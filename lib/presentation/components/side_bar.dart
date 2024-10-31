import 'package:flutter/material.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';

class Sidebar extends StatelessWidget {
  final int selectedPage;
  final ValueChanged<int> onItemTapped;

  const Sidebar({
    Key? key,
    required this.selectedPage,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: DesignSystem.colors.secondary,
      selectedIndex: selectedPage,
      onDestinationSelected: onItemTapped,
      labelType: NavigationRailLabelType.all,
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon:  Icon(Icons.text_fields, color: DesignSystem.colors.textDetail),
          selectedIcon: const Icon(Icons.text_fields),
          label:  Text('Prompt',style: TextStyle(color: DesignSystem.colors.textDetail)),
        ),
        NavigationRailDestination(
          icon:  Icon(Icons.message, color: DesignSystem.colors.textDetail),
          selectedIcon: const Icon(Icons.message),
          label: Text('Mensagem',style: TextStyle(color: DesignSystem.colors.textDetail)),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.history, color: DesignSystem.colors.textDetail),
          selectedIcon: const Icon(Icons.history),
          label: Text('Histórico', style: TextStyle(color: DesignSystem.colors.textDetail)),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings, color: DesignSystem.colors.textDetail),
          selectedIcon: const Icon(Icons.settings),
          label: Text('Configurações', style: TextStyle(color: DesignSystem.colors.textDetail)),
        ),
      ],
    );
  }
}

