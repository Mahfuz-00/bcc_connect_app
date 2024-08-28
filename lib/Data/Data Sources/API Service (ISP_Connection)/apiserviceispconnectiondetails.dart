import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for managing ISP connection-related API requests.
class APIServiceISPConnection {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServiceISPConnection.create(this.authToken);

  /// Fetches dashboard data from the API.
  ///
  /// - Returns: A future that completes with a map of the dashboard data.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$URL/dashboard'),
        headers: {'Authorization': 'Bearer $authToken'},
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
