part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoadingState extends HomeState{}
class HomeCompleted extends HomeState{

  final HomeModel homeModel;

  HomeCompleted({required this.homeModel});
}
class HomeError extends HomeState{
  final ErrorMessageClass error;

  HomeError({required this.error});
}
