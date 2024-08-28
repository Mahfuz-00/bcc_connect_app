import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for managing full ISP connection-related API requests.
class APIServiceISPConnectionFull {
  late final String authToken;

  APIServiceISPConnectionFull.create(this.authToken);

  /// Fetches full data from the specified URL.
  ///
  /// - Parameter url: The URL from which to fetch data.
  ///
  /// - Returns: A future that completes with a map of the full data.
  ///
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchFullData(String url) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse(url),
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
