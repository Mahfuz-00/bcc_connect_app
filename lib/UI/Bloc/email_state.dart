part of 'email_cubit.dart';

abstract class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object> get props => [];
}

class EmailInitial extends EmailState {}

class EmailSaved extends EmailState {
  final String email;

  const EmailSaved({required this.email});

  @override
  List<Object> get props => [email];
}
