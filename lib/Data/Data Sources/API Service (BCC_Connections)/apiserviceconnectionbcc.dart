import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for interacting with the BCC Connection API.
///
/// This class provides functionality to fetch dashboard items by sending a
/// GET request to the API.
///
/// **Actions:**
/// - [fetchDashboardItems]: Sends a GET request to retrieve dashboard items
///   and returns the response data as a map.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token required for making API requests.
class BCCConnectionAPIService {
  final String baseUrl = 'http://114.130.240.150/api';
  late final String authToken;

  BCCConnectionAPIService.create(this.authToken);

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
