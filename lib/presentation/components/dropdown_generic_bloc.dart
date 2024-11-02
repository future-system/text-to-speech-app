import 'package:bloc/bloc.dart';

class DropdownGenericBloc<T> extends Cubit<T?> {
  DropdownGenericBloc() : super(null);

  void choose(T value) => emit(value);

  void clear() => emit(null);

}