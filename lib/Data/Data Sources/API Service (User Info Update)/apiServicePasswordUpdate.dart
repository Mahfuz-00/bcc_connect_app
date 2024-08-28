import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling password updates.
class APIServicePasswordUpdate {
  String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServicePasswordUpdate.create(this.authToken);

  /// Updates the user's password.
  ///
  /// - Parameters:
  ///   - `currentPassword`: The current password of the user.
  ///   - `newPassword`: The new password to set.
  ///   - `passwordConfirmation`: Confirmation of the new password.
  /// - Returns: A `Future` that completes with a message from the server.
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final String token = await authToken;
    try {
      print('API Token :: $authToken');
      print('Current $currentPassword');
      print('New $newPassword');
      print('Confirm $passwordConfirmation');

      final requestBody = jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'password_confirmation': passwordConfirmation,
      });

      print('Request Body: $requestBody');
      print('Auth: $authToken');

      final response = await http.post(
        Uri.parse('$baseURL/update/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('password');
        final responseData = jsonDecode(response.body);
        print(response.body);
        final responseMessage = responseData['message'];

        print(responseMessage);
        return responseMessage;
      } else {
        print(response.statusCode);
        print(response.body);
        final responseData = jsonDecode(response.body);
        final responseError = responseData['errors'];
        print(responseError);
        final List<dynamic> responseMessageList =
            responseError['current_password'];
        final String responseMessage = responseMessageList.join(', ');
        print(responseMessage);
        print(response.request);
        return responseMessage.toString();
      }
    } catch (e) {
      throw Exception('Failed to update Password: $e');
    }
  }
}
