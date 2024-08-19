import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling API requests related to BCC connection dashboard.
class BCCConnectionAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  BCCConnectionAPIService._();

  /// Creates an instance of `BCCConnectionAPIService` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `BCCConnectionAPIService`.
  static Future<BCCConnectionAPIService> create() async {
    var apiService = BCCConnectionAPIService._();
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
  /// - Returns: A future that completes once the token is loaded.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  /// Fetches dashboard items from the API.
  ///
  /// - Returns: A future that completes with a `Map<String, dynamic>` containing dashboard items.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchDashboardItems() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}
