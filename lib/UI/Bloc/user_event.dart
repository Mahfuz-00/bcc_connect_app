part of 'user_bloc.dart';

sealed class UserEvent {}

class LoadUser extends UserEvent {
  final String name;
  final String organizationName;
  final String photo;
  final String id;

  LoadUser({
    required this.name,
    required this.organizationName,
    required this.photo,
    required this.id,
  });
}

class loadToken extends UserEvent {
  final String token;

  loadToken({
    required this.token,
  });
}


