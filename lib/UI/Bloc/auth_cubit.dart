import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Data/Models/profileModelFull.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(UserProfile userProfile, String token) {
    emit(AuthAuthenticated(userProfile: userProfile, token: token));
    print('User profile and token saved in Cubit:');
    print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.organization}, ${userProfile.photo}');
    print('Token: $token');
  }

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

  void logout() {
    emit(AuthInitial());
    print('User profile and token removed from Cubit');
  }
}
