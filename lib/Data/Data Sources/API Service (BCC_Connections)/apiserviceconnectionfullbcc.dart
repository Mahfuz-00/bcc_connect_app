import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for interacting with the BCC Full Connection API.
///
/// This class is responsible for fetching full dashboard items from a specified
/// URL using a GET request.
///
/// **Actions:**
/// - [fetchFullDashboardItems]: Sends a GET request to the specified [url]
///   and returns the response data as a map.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
class BCCFullConnectionAPIService {
  late final String authToken;

  BCCFullConnectionAPIService.create(this.authToken);

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
