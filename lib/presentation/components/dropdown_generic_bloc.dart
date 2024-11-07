import 'package:bloc/bloc.dart';

class DropdownGenericBloc<T> extends Cubit<T?> {
  DropdownGenericBloc({T? value}) : super(value);

  void choose(T value) => emit(value);

  void clear() => emit(null);

}