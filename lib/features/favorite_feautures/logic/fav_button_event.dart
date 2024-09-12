part of 'fav_button_bloc.dart';

@immutable
abstract class FavButtonEvent {
  final String id;
  FavButtonEvent(this.id);
}

class AddToFavoriteEvent extends FavButtonEvent {
  AddToFavoriteEvent(super.id);
}
