import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for sending OTP for forgot password requests.
class APIServiceForgotPassword {
  final String url =
      'https://bcc.touchandsolve.com/api/send/forget/password/otp';
  late final String authToken;

  // Private constructor for singleton pattern.
  APIServiceForgotPassword._();
  APIServiceForgotPassword();

  /// Creates an instance of `APIServiceForgotPassword` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `APIServiceForgotPassword`.
  static Future<APIServiceForgotPassword> create() async {
    var apiService = APIServiceForgotPassword._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIServiceForgotPassword() {
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

  /// Sends a request to generate an OTP for forgotten password.
  ///
  /// - Parameters:
  ///   - [email]: The email associated with the account.
  ///
  /// - Returns: A future that completes with a message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<String> sendForgotPasswordOTP(String email) async {
   /* if (authToken.isEmpty) {
      print(authToken);
      await _loadAuthToken();
      throw Exception('Authentication token is empty.');
    }*/
    print(email);
   // print(authToken);
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'email': email,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('Forgot password OTP sent successfully.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print(
            'Failed to send forgot password OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }
    } catch (e) {
      print('Error sending forgot password OTP: $e');
      return 'Error sending forgot password OTP';
    }
  }
}
