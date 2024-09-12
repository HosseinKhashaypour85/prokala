import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/home_features/model/home_model.dart';
import 'package:prokalaproject/features/public_features/error/error_exception.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../../../services/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository) : super(HomeInitial()) {
    on<CallHomeEvent>(_callHomeApi);
  }

  FutureOr<void> _callHomeApi(
      CallHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      HomeModel _homeMode = await HomeRepository().callIndexApi();
      emit(HomeCompleted(homeModel: _homeMode));
    } on DioException catch (e) {
      emit(HomeError(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }
}
