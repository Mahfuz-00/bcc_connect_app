import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling API requests related to full dashboard items from BCC connection.
class BCCFullConnectionAPIService {
  late final String authToken;

  // Private constructor for singleton pattern.
  BCCFullConnectionAPIService._();

  /// Creates an instance of `BCCFullConnectionAPIService` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `BCCFullConnectionAPIService`.
  static Future<BCCFullConnectionAPIService> create() async {
    var apiService = BCCFullConnectionAPIService._();
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

  /// Fetches full dashboard items from the API using the provided URL.
  ///
  /// - Parameters:
  ///   - [url]: The URL endpoint to fetch dashboard items from.
  ///
  /// - Returns: A future that completes with a `Map<String, dynamic>` containing the dashboard items.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchFullDashboardItems(String url) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse(url),
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
