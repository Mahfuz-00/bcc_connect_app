import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for sending OTP for forgot password requests.
class APIServiceForgotPassword {
  final String url =
      'https://bcc.touchandsolve.com/api/send/forget/password/otp';
  late final String authToken;

  APIServiceForgotPassword.create();
  APIServiceForgotPassword();

  /// Sends a request to generate an OTP for forgotten password.
  ///
  /// - Parameters:
  ///   - [email]: The email associated with the account.
  ///
  /// - Returns: A future that completes with a message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<String> sendForgotPasswordOTP(String email) async {
    print(email);
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
