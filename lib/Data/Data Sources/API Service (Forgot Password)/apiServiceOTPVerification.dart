import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for OTP verification requests.
class APIServiceOTPVerification {
  final String url = 'https://bcc.touchandsolve.com/api/verify/otp';
  late final String authToken;

  // Private constructor for singleton pattern.
  APIServiceOTPVerification._();

  /// Creates an instance of `APIServiceOTPVerification` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `APIServiceOTPVerification`.
  static Future<APIServiceOTPVerification> create() async {
    var apiService = APIServiceOTPVerification._();
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

  /// Verifies the OTP for a given email.
  ///
  /// - Parameters:
  ///   - [email]: The email associated with the account.
  ///   - [OTP]: The OTP to be verified.
  ///
  /// - Returns: A future that completes with a message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<String> OTPVerification(String email, String OTP) async {
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
      'otp': OTP,
    };

    final String requestBodyJson = jsonEncode(requestBody);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('OTP Invoked.');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      } else {
        print('Failed to send OTP. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        var message = jsonResponse['message'];
        return message;
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return 'Error sending OTP';
    }
  }
}
