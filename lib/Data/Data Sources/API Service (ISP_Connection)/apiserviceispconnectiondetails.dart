import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class APIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIService._();

  static Future<APIService> create() async {
    var apiService = APIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/dashboard'),
        headers: {'Authorization': 'Bearer $token'}, // Pass the actual token, not the future
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data; // Return the JSON body directly
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}
