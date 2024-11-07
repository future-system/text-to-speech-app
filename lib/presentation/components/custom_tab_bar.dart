import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_generic_bloc.dart';

class CustomTabBar extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget> children;

  const CustomTabBar({required this.tabs, required this.children, super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this);
  late final DropdownGenericBloc<bool> bloc = DropdownGenericBloc<bool>(value: false);

  @override
  void initState() {
    controller.addListener(() => bloc.choose(!bloc.state!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: controller,
            tabs: widget.tabs,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: BlocBuilder<DropdownGenericBloc<bool>, bool?>(
              bloc: bloc,
              builder: (context, state) {
                return widget.children[controller.index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
