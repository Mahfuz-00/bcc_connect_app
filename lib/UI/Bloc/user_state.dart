part of 'user_bloc.dart';

sealed class UserState {}

class UserInitial extends UserState {}

class UserNameLoaded extends UserState {
  final String name;

  UserNameLoaded({required this.name}){
    print('Bloc Name : $name');
    print('Name Done!!');
  }
}

class UserOrganizationNameLoaded extends UserState {
  final String organizationName;

  UserOrganizationNameLoaded({required this.organizationName}){
    print('Bloc Organization Name : $organizationName');
    print('Org Name Done!!');
  }
}

class UserPhotoLoaded extends UserState {
  final String photo;

  UserPhotoLoaded({required this.photo}){
    print('Bloc Photo : $photo');
    print('Photo Done!!');
  }
}

class UserIdLoaded extends UserState {
  final String id;

  UserIdLoaded({required this.id}){
    print('Bloc ID : $id');
    print('ID Done!!');
  }
}

class UserToken extends UserState {
  final String token;
  UserToken({required this.token}) {
    print('Bloc Token : $token');
    print('Token Done!!');
  }
}
