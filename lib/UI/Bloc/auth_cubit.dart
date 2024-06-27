import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/profilemodel.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(UserProfile userProfile, String token) {
    emit(AuthAuthenticated(userProfile: userProfile, token: token));
    print('User profile and token saved in Cubit:');
    print('User Profile: ${userProfile.Id}, ${userProfile.name}, ${userProfile.organization}, ${userProfile.photo}');
    print('Token: $token');
  }

  void logout() {
    emit(AuthInitial());
  }
}
