import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling NTTN connection-related operations.
class NTTNConnectionAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NTTNConnectionAPIService.create(this.authToken);

  /// Fetches NTTN connection-related data from the server.
  ///
  /// - Returns: A `Future` that completes with a `Map<String, dynamic>` containing the JSON response.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchConnections() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
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
