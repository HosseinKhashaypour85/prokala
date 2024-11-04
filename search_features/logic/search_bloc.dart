import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';
import 'package:prokalaproject/features/search_features/model/search_model.dart';

import '../services/search_repository_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent , SearchState> {
  final SearchRepositoryServices searchRepositoryServices;
  SearchBloc(this.searchRepositoryServices) : super(SearchInitial()) {
    on<CallSearchEvent>(_callSearchApi);
  }

  FutureOr<void> _callSearchApi(CallSearchEvent event, Emitter<SearchState> emit) async{
    emit(SearchLoadingState());
    try{
      final SearchModel searchModel = await searchRepositoryServices.callSearchApi(event.search);
      emit(SearchCompletedState(searchModel));
    }
        on DioException catch(e){}
  }
}
