import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for managing NTTN connection-related API requests.
///
/// This class is responsible for fetching connection data from the NTTN API.
///
/// **Actions:**
/// - [fetchConnections]: Sends a GET request to retrieve connection data from
///   the dashboard and returns the data as a map.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the NTTN API.
/// - [authToken]: The authentication token used for API requests.
class NTTNConnectionAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NTTNConnectionAPIService.create(this.authToken);

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
