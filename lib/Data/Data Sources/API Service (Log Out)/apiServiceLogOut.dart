import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling user sign-out operations.
class LogOutApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  LogOutApiService._();

  /// Creates an instance of `LogOutApiService` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `LogOutApiService`.
  static Future<LogOutApiService> create() async {
    var apiService = LogOutApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  LogOutApiService() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }*/

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
    //return token;
  }

  /// Signs out the user by making a GET request to the sign-out endpoint.
  ///
  /// - Returns: A future that completes with a boolean indicating success or failure.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<bool> signOut() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

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
