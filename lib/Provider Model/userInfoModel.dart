import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  late String userName = '';
  late String organizationName ='';
  late String photoURL  = '';

  void updateUserProfile({
    required String userName,
    required String organizationName,
    required String photoURL,
  }) {
    this.userName = userName;
    this.organizationName = organizationName;
    this.photoURL = 'https://bcc.touchandsolve.com$photoURL';
    notifyListeners();
  }
}
