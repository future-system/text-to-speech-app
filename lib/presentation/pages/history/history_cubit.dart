
import 'package:bloc/bloc.dart';
import 'package:text_to_speech_flutter/data/models/history_model.dart';
import 'package:text_to_speech_flutter/presentation/pages/history/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit():super(HistoryState(histories: []));

  insert(HistoryModel model){
    final histories = state.histories;
    histories.add(model);
    emit(state.copyWith(histories: histories.reversed.toList()));
  }

}