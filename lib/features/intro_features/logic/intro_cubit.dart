import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<int> {
  IntroCubit() : super(0);

  int CurrentIndex = 0;

 changeIndex(int index){
   emit(CurrentIndex = index);
 }



}
