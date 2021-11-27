abstract class AuthState {}

class UnKnownAuthState extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  Authenticated({required this.userId});
}

class Unauthenticated extends AuthState {}
