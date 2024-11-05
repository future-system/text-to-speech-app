
import 'package:text_to_speech_flutter/data/models/history_model.dart';

class HistoryState {

  HistoryState({required this.histories});

  final List<HistoryModel> histories;

  HistoryState copyWith({required List<HistoryModel>? histories})=> HistoryState(histories: histories ?? this.histories);
}