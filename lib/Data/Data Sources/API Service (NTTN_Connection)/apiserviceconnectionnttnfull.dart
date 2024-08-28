import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling full NTTN connection-related operations.
class NTTNFullConnectionAPIService {
  late final String authToken;

  NTTNFullConnectionAPIService.create(this.authToken);

  /// Fetches full NTTN connection-related data from a given URL.
  ///
  /// - Parameters:
  ///   - url: The endpoint from which to fetch the connection data.
  /// - Returns: A `Future` that completes with a `Map<String, dynamic>` containing the JSON response.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchFullConnections(String url) async {
    try {
      print('API Token :: $authToken');
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
