import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for creating a new password.
class APIServiceCreateNewPassword {
  final String url = 'https://bcc.touchandsolve.com/api/forget/password';
  late final String authToken;

  // Private constructor for singleton pattern.
  APIServiceCreateNewPassword._();

  /// Creates an instance of `APIServiceCreateNewPassword` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `APIServiceCreateNewPassword`.
  static Future<APIServiceCreateNewPassword> create() async {
    var apiService = APIServiceCreateNewPassword._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIServiceOTPVerification() {
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

  /// Sends a request to create a new password.
  ///
  /// - Parameters:
  ///   - [email]: The email associated with the account.
  ///   - [password]: The new password.
  ///   - [confirmPassword]: Confirmation of the new password.
  ///
  /// - Returns: A future that completes with a message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<String> NewPassword(
      String email, String password, String confirmPassword) async {
    if (authToken.isEmpty) {
      print(authToken);
      await _loadAuthToken();
      throw Exception('Authentication token is empty.');
    }
    print(email);
    print(authToken);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
      'new_password': password,
      'password_confirmation': confirmPassword,
    };

    // Encode the request body as JSON
    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('New Password Created successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print(
            'Failed to create new password. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }
    } catch (e) {
      print('Error creating new password: $e');
      return 'Error creating new password';
    }
  }
}
