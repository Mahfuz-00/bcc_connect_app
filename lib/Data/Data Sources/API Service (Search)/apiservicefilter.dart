import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling search filter operations.
class SearchFilterAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  SearchFilterAPIService._();

  /// Creates and initializes a new instance of `SearchFilterAPIService`.
  ///
  /// - Returns: A `Future` that completes with an instance of `SearchFilterAPIService`.
  static Future<SearchFilterAPIService> create() async {
    var apiService = SearchFilterAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  /// Initializes a new instance of `SearchFilterAPIService` and loads the authentication token.
  SearchFilterAPIService() {
    _loadAuthToken();
    print('triggered');
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

  /// Filters NTTN connections based on provided request data.
  ///
  /// - Parameters:
  ///   - `requestData` - A map containing the filter criteria.
  /// - Returns: A `Future` that completes with the filtered data.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> filterNTTNConnection(Map<String, dynamic> requestData) async {
    print(requestData);
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print('Authen:: $authToken');
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.post(
        Uri.parse('$baseUrl/filter/nttn/connection'),
        headers: {'Authorization': 'Bearer $authToken'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to filter NTTN connection: ${response.reasonPhrase},  ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering NTTN connection: $e');
    }
  }
}
