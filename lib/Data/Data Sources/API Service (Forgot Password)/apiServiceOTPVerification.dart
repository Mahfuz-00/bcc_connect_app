import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for OTP verification requests.
class APIServiceOTPVerification {
  final String url = 'https://bcc.touchandsolve.com/api/verify/otp';
  late final String authToken;

  APIServiceOTPVerification.create();

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
    print(email);
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
