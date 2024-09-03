import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for updating the user's password via an API.
///
/// This class is responsible for handling the password update process,
/// including validating the current password and sending the new password
/// to the server.
///
/// **Variables:**
/// - [baseURL]: The base API endpoint for the password update.
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [updatePassword]: Sends a POST request to update the user's password
///   using the provided [currentPassword], [newPassword], and
///   [passwordConfirmation].
class PasswordUpdateAPIService {
  String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PasswordUpdateAPIService.create(this.authToken);

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
