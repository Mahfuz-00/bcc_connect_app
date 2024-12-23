import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for fetching user profile information from an API.
///
/// This class is responsible for retrieving the user's profile data by making an API request.
///
/// **Variables:**
/// - [URL]: The base URL of the API endpoint.
///
/// **Actions:**
/// - [fetchUserProfile]: Sends a GET request to the API to fetch
/// the user profile data using the provided [authToken].
class ProfileAPIService {
  final String URL = 'http://114.130.240.150/api';

  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    print('Authen: $authToken');
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
