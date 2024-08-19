import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// The `APIProfileService` class is responsible for handling requests related to user profile data.
class APIProfileService {
  final String URL = 'https://bcc.touchandsolve.com/api';

  // Private constructor for singleton pattern.
  late final String authToken;

/*
  APIProfileService._();

  static Future<APIProfileService> create() async {
    var apiService = APIProfileService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }*/

  /// Fetches the user profile from the server.
  ///
  /// - Parameters:
  ///   - authToken: The authentication token required to authorize the request.
  /// - Returns: A `Future` that completes with a `Map<String, dynamic>` containing the user's profile data.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    print('Authen: $authToken');
    //final String token = await authToken;
    try {
      if (authToken.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200) {
        print('Profile Loaded successfully.');
        Map<String, dynamic> userProfile = json.decode(response.body);
        print(response.body);
        return userProfile['records'];
      } else {
        print('Failed to load Profile. Status code: ${response.statusCode}');
        throw Exception('Failed to load Profile.');
      }
    } catch (e) {
      print('Error sending profile request: $e');
      throw Exception('Error sending profile request');
    }
  }
}
