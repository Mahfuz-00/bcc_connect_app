import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'ispconnectiondetailsmodel.dart';

/// Service class for fetching connection data for a specific user.
class FetchedConnectionListAPIService {
  final String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  FetchedConnectionListAPIService._();

  /// Creates an instance of `FetchedConnectionListAPIService` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `FetchedConnectionListAPIService`.
  static Future<FetchedConnectionListAPIService> create() async {
    var apiService = FetchedConnectionListAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  /// Fetches connection data for a specific user from the API.
  ///
  /// - Parameters:
  ///   - [userId]: The ID of the user for whom to fetch connection data.
  ///
  /// - Returns: A future that completes with a [Map<String, dynamic>] containing the connection data.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchConnectionData(int userId) async {
    try {
      if (authToken.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$baseURL/bcc/getconnections/$userId'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load connection data');
      }
    } catch (e) {
      throw Exception('Error fetching connection data: $e');
    }
  }
}
