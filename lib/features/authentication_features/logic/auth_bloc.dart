import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/public_features/error/error_exception.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../services/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<CallAuthEvent>(_callAuth);
  }

  FutureOr<void> _callAuth(CallAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final String? token = await authRepository.CallAuthApi(event.phoneNumber);
      emit(AuthCompletedState(token!));
    } on DioException catch (e) {
      emit(AuthErrorState(
          ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }
}
