import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling API requests related to full dashboard items from BCC connection.
class BCCFullConnectionAPIService {
  late final String authToken;

  BCCFullConnectionAPIService.create(this.authToken);

  /// Fetches full dashboard items from the API using the provided URL.
  ///
  /// - Parameters:
  ///   - [url]: The URL endpoint to fetch dashboard items from.
  ///
  /// - Returns: A future that completes with a `Map<String, dynamic>` containing the dashboard items.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchFullDashboardItems(String url) async {
    try {
      print('API Token :: $authToken');
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
