import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserDataBloc extends Cubit<UserState> {
  UserDataBloc() : super(UserInitial());

  void saveName(String name) {
    emit(UserNameLoaded(name: name));
  }

  void saveOrganizationName(String organizationName) {
    emit(UserOrganizationNameLoaded(organizationName: organizationName));
  }

  void savePhoto(String photo) {
    emit(UserPhotoLoaded(photo: photo));
  }

  void saveId(String id) {
    emit(UserIdLoaded(id: id));
  }

  void saveToken(String token) {
    emit(UserToken(token: token));
  }

}
