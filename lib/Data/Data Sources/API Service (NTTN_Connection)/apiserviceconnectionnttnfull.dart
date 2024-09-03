import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for managing full NTTN connection-related API requests.
///
/// This class is responsible for fetching full connection data from a given URL.
///
/// **Actions:**
/// - [fetchFullConnections]: Sends a GET request to retrieve full connection
///   data from the specified [url] and returns the data as a map.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
class NTTNFullConnectionAPIService {
  late final String authToken;

  NTTNFullConnectionAPIService.create(this.authToken);

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
