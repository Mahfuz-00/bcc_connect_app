import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling full NTTN connection-related operations.
class NTTNFullConnectionAPIService {
  late final String authToken;

  // Private constructor for singleton pattern.
  NTTNFullConnectionAPIService._();

  /// Creates and initializes a new instance of `NTTNFullConnectionAPIService`.
  ///
  /// - Returns: A `Future` that completes with an instance of `NTTNFullConnectionAPIService`.
  static Future<NTTNFullConnectionAPIService> create() async {
    var apiService = NTTNFullConnectionAPIService._();
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

  /// Fetches full NTTN connection-related data from a given URL.
  ///
  /// - Parameters:
  ///   - url: The endpoint from which to fetch the connection data.
  /// - Returns: A `Future` that completes with a `Map<String, dynamic>` containing the JSON response.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchFullConnections(String url) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
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
