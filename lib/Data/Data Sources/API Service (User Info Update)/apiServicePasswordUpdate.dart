import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIServicePasswordUpdate {
  String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServicePasswordUpdate._();

  static Future<APIServicePasswordUpdate> create() async {
    var apiService = APIServicePasswordUpdate._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIServiceUpdateUser() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final String token = await authToken;
    print('Authen:: $authToken');
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

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
        // Request successful, parse response data if needed
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
        final List<dynamic> responseMessageList = responseError['current_password'];
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
