part of 'token_check_cubit.dart';

@immutable
abstract class TokenCheckState {}

class TokenCheckInitial extends TokenCheckState {}
class TokenIsLoged extends TokenCheckState{}
class TokenIsNotLoged extends TokenCheckState{}

