import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIProfileService {
  final String URL = 'https://bcc.touchandsolve.com/api';

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

  Future<Map<String, dynamic>> fetchUserProfile(String authToken) async {
    print('Authen: $authToken');
    //final String token = await authToken; // Wait for the authToken to complete
    try{
        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }


      final response = await http.get(
        Uri.parse('$URL/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          // Add other headers if needed
        },
      );
        print(response.statusCode);

      print(response.body);
      if (response.statusCode == 200) {
        print('Profile Loaded successfully.');
        // If the server returns a 200 OK response, parse the JSON
        Map<String, dynamic> userProfile = json.decode(response.body);
        print(response.body);
        return userProfile['records'];
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        print('Failed to load Profile. Status code: ${response.statusCode}');
        throw Exception('Failed to load Profile.');
      }
    } catch(e){
      print('Error sending profile request: $e');
      throw Exception('Error sending profile request');
    }
  }
}
