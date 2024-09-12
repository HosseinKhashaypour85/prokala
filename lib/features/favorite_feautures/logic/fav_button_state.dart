part of 'fav_button_bloc.dart';

@immutable
abstract class FavButtonState {}

class FavButtonInitial extends FavButtonState {}

class FavButtonLoadingState extends FavButtonState {}

class FavButtonCompletedState extends FavButtonState {
  final bool status;
  FavButtonCompletedState(this.status);
}

class FavButtonErrorState extends FavButtonState {
  final ErrorMessageClass error;
  FavButtonErrorState({required this.error});
}
