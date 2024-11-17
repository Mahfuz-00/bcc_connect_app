part of 'auth_cubit.dart';

/// Represents the authentication state of the application.
///
/// This abstract class serves as the base for all authentication-related
/// states. It extends [Equatable] to allow for easy comparison of states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// The initial state of the authentication process.
///
/// This state indicates that no user is authenticated yet.
class AuthInitial extends AuthState {}

/// Represents the authenticated state of a user.
///
/// This state is emitted when a user successfully logs in. It contains
/// the user's profile information and a valid authentication token.
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
  List<Object> get props => [userProfile, token, usertype];
}
