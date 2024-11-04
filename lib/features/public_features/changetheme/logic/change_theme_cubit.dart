import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/const/theme/theme.dart';


class ChangethemeCubit extends Cubit<ThemeData> {
  ChangethemeCubit() : super(ThemeData.light());

  ThemeData customTheme = CustomTheme.lightTheme;

  changeTheme(){
    if(customTheme == CustomTheme.darkTheme){
      emit(customTheme = CustomTheme.lightTheme);
    } else{
      emit(customTheme = CustomTheme.darkTheme);
    }
  }
}
