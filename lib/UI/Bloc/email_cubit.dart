import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'email_state.dart';

class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailInitial());

  // Method to save the email and emit the state
  void saveEmail(String email) {
    emit(EmailSaved(email: email));
    print('Email saved in Cubit: $email');
  }

  void clearEmail() {
    emit(EmailInitial());
    print('Email cleared from Cubit');
  }
}

