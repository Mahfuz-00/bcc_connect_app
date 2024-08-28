part of 'auth_cubit.dart';

/// Abstract class representing the base state for authentication.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// State representing the initial state of authentication.
class AuthInitial extends AuthState {}

/// State representing an authenticated user.
class AuthAuthenticated extends AuthState {
  final UserProfile userProfile;
  final String token;
  final String usertype;

  const AuthAuthenticated({
    required this.userProfile,
    required this.token,
    required this.usertype,
  });

  @override
  List<Object> get props => [userProfile, token];
}
