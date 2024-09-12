import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../../public_features/error/error_exception.dart';
import '../services/favorite_repository.dart';

part 'fav_button_event.dart';

part 'fav_button_state.dart';

class FavButtonBloc extends Bloc<FavButtonEvent, FavButtonState> {
  final FavoriteRepository favoriteRepository;
  FavButtonBloc(this.favoriteRepository) : super(FavButtonInitial()) {
    on<FavButtonEvent>(_addToFav);
  }

  FutureOr<void> _addToFav(
      FavButtonEvent event, Emitter<FavButtonState> emit) async{
    emit(FavButtonLoadingState());
    try{
      final bool status = await favoriteRepository.addToFavorite(event.id);
      emit(FavButtonCompletedState(status));
    }
        on DioException catch(e){
      emit(FavButtonErrorState(error : ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
        }
  }
}
