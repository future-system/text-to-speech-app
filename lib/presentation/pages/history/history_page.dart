import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_to_speech_flutter/core/constants/design_system.dart';
import 'package:text_to_speech_flutter/core/navigation.dart';
import 'package:text_to_speech_flutter/data/models/history_model.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_cubit.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<HistoryModel> promptHistory = [];

  late final HistoryCubit historyCubit;

  @override
  void initState() {
    super.initState();
    historyCubit = context.read<HistoryCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HistoryCubit, HistoryState>(
        bloc: historyCubit,
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.histories.length,
            itemBuilder: (context, index) {
              final item = state.histories[index];
              final prompt = item.content;
              final dateTime = item.date;

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
          );
        }
      ),
    );
  }
}
