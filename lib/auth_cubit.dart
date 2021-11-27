import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/auth_repository.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _authRepository = AuthRepository();

  AuthCubit() : super(UnKnownAuthState());

  void signIn() async {
    await _authRepository
        .webSignIn()
        .then((userId) => _handleUserId(userId))
        .catchError(_handleError);
  }

  _handleError(Object? e) {
    e is Exception ? emit(Unauthenticated()) : () {};
  }

  signOut() async {
    await _authRepository.signOut().catchError(_handleError);
    emit(Unauthenticated());
  }

  attemptAutoSignIn() async {
    await _authRepository
        .attemptAutoSignIn()
        .then((userId) => _handleError(userId))
        .catchError(_handleError);
  }

  _handleUserId(String userId) {
    userId.isNotEmpty
        ? emit(Authenticated(userId: userId))
        : emit(Unauthenticated());
  }
}
