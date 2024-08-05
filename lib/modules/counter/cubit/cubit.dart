import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates> {
  CounterCubit() : super(CounterInitialState());

  // CounterCubit cubit = BlocProvider.of();
  // to be more easily when use this cubit in many places
  int counter = 1;

  static CounterCubit? get(context) => BlocProvider.of(context);

  void minus() {
    counter--;
    emit(CounterMinusState(counter));
  }

  void plus() {
    counter++;
    emit(CounterPlusState(counter));
  }
}
