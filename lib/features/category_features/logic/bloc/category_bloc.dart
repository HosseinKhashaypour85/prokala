
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:prokalaproject/features/category_features/model/category_model.dart';
import 'package:prokalaproject/features/category_features/services/category_repository.dart';
import 'package:prokalaproject/features/public_features/error/error_exception.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState>{

 final CategoryRepository repository;


  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<CallCategory>((event, emit)async{
      emit(CategoryLoadingState());

      try {
        CategoryModel categoryModel = await repository.fetchCategoryModel();
        emit(CategoryCompletedState(categoryModel));
      }
          on DioException catch(e){
        emit(CategoryErrorState(ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
          }
    });
  }
}
