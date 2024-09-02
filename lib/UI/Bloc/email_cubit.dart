import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'email_state.dart';

/// A Cubit class for managing [email] state.
///
/// This Cubit is responsible for handling the [email] state within the application.
/// It allows for saving and clearing the [email], emitting the appropriate states
/// to notify listeners of changes.
class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailInitial());

  void saveEmail(String email) {
    emit(EmailSaved(email: email));
    print('Email saved in Cubit: $email');
  }

  void clearEmail() {
    emit(EmailInitial());
    print('Email cleared from Cubit');
  }
}

