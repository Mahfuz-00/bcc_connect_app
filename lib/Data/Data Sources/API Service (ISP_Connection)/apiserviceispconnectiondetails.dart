import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for managing ISP connection-related API requests.
class APIServiceISPConnection {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  APIServiceISPConnection._();

  /// Creates an instance of `APIServiceISPConnection` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `APIServiceISPConnection`.
  static Future<APIServiceISPConnection> create() async {
    var apiService = APIServiceISPConnection._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  /// Fetches dashboard data from the API.
  ///
  /// - Returns: A future that completes with a map of the dashboard data.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchDashboardData() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/dashboard'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}
