import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Data/Models/profilemodel.dart';

part 'auth_state.dart';

/// A Cubit class responsible for managing user authentication state.
///
/// The `AuthCubit` handles user authentication actions such as login, logout,
/// and fetching or updating the user profile. It emits different states
/// based on the user's actions.
///
/// ### States:
/// - [AuthInitial]: The initial state when no user is authenticated.
/// - [AuthAuthenticated]: The state when a user is authenticated with a valid profile and token.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> initializeAuthState() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final userType = await _secureStorage.read(key: 'user_type');

      if (token != null && userType != null && token.isNotEmpty && userType.isNotEmpty) {
        print('Emiting authentication');
        final userProfile = UserProfile(
          Id: 0,
          name: 'N/A',
          organization: 'N/A',
          photo: 'N/A',
        );
        emit(AuthAuthenticated(userProfile: userProfile, token: token, usertype: userType));
      } else {
        print('No authentication data found in secure storage');
        emit(AuthInitial());
      }
    } catch (e) {
      print('Error initializing authentication state: $e');
      emit(AuthInitial());
    }
  }

  /// Logs in a user by saving their profile and token.
  ///
  /// - Parameters:
  ///   - `userProfile`: An instance of `UserProfile` containing user details.
  ///   - `token`: A string representing the authentication token.
  Future<void> login(UserProfile userProfile, String token, String type) async {
    emit(AuthAuthenticated(userProfile: userProfile, token: token, usertype: type));
    await _secureStorage.write(key: 'auth_token', value: token);
    await _secureStorage.write(key: 'user_type', value: type);

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
        usertype: currentState.usertype,
      ));
      print('User profile updated in Cubit:');
      print('User Profile: '
          'Token: ${currentState.token}, '
          'UserType: ${currentState.usertype}, '
          'User ID: ${userProfile.Id}, '
          'User Name: ${userProfile.name}, '
          'User Organization: ${userProfile.organization}, '
          'Photo: ${userProfile.photo}');
    }
  }

  /// Logs out the user by resetting the state.
  Future<void> logout() async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      print('User profile and token removed from Cubit');
      print('User Profile: '
          'Token: ${currentState.token}, '
          'UserType: ${currentState.usertype}, '
          'User ID: ${currentState.userProfile.Id}, '
          'User Name: ${currentState.userProfile.name}, '
          'User Organization: ${currentState.userProfile.organization}, '
          'Photo: ${currentState.userProfile.photo}');
    }
    emit(AuthInitial());

    // Remove data from secure storage
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_type');

    // After resetting, confirm that the data has been removed
    if (state is AuthInitial) {
      print('User profile and token are now empty.');
    } else {
      print('Failed to reset state.');
    }
  }
}
