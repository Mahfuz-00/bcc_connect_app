import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIServicePasswordUpdate {
  static const String baseURL = 'https://bcc.touchandsolve.com/api/';
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

  Future<Map<String, dynamic>> updatePassword({
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

      print(currentPassword);
      print(newPassword);
      print(passwordConfirmation);


      final response = await http.post(
        Uri.parse('$baseURL/update/password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(<String, String>{
          'current_password': currentPassword,
          'new_password': newPassword,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        // Request successful, parse response data if needed
        final responseData = jsonDecode(response.body);
        print(response.body);
        return responseData;
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception(
            'Failed to update password: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update Password: $e');
    }
  }
}
