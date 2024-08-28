import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling user sign-out operations.
class LogOutApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  LogOutApiService.create(this.authToken);


  /// Signs out the user by making a GET request to the sign-out endpoint.
  ///
  /// - Returns: A future that completes with a boolean indicating success or failure.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<bool> signOut() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Sign out successful');
        return true;
      } else {
        print(response.body);
        print('Failed to sign out: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      print(response.body);
      print('Exception during sign out: $e');
      return false;
    }
  }
}
