import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling API requests related to BCC connection dashboard.
class BCCConnectionAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  BCCConnectionAPIService.create(this.authToken);

  /// Fetches dashboard items from the API.
  ///
  /// - Returns: A future that completes with a `Map<String, dynamic>` containing dashboard items.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchDashboardItems() async {
    try {
      print('API Token :: $authToken');
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
