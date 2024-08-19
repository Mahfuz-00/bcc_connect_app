import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Data/Models/profileModelFull.dart';

part 'auth_state.dart';

/// Cubit for managing authentication state.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// Logs in a user by saving their profile and token.
  ///
  /// - Parameters:
  ///   - `userProfile`: An instance of `UserProfile` containing user details.
  ///   - `token`: A string representing the authentication token.
  void login(UserProfile userProfile, String token) {
    emit(AuthAuthenticated(userProfile: userProfile, token: token));
    print('User profile and token saved in Cubit:');
    print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.organization}, ${userProfile.photo}');
    print('Token: $token');
  }

  /// Updates the user's profile information.
  ///
  /// - Parameters:
  ///   - `userProfile`: An instance of `UserProfile` containing updated user details.
  void updateProfile(UserProfile userProfile) {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(AuthAuthenticated(
        userProfile: userProfile,
        token: currentState.token,
      ));
      print('User profile updated in Cubit:');
      print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.organization}, ${userProfile.photo}');
    }
  }

  /// Logs out the user by resetting the state.
  void logout() {
    emit(AuthInitial());
    print('User profile and token removed from Cubit');
  }
}
