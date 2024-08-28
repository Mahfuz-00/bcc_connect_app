import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for fetching connection data for a specific user.
class FetchedConnectionListAPIService {
  final String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  FetchedConnectionListAPIService.create(this.authToken);

  /// Fetches connection data for a specific user from the API.
  ///
  /// - Parameters:
  ///   - [userId]: The ID of the user for whom to fetch connection data.
  ///
  /// - Returns: A future that completes with a [Map<String, dynamic>] containing the connection data.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<Map<String, dynamic>> fetchConnectionData(int userId) async {
    try {
      print('API Token :: $authToken');

      final response = await http.get(
        Uri.parse('$baseURL/bcc/getconnections/$userId'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load connection data');
      }
    } catch (e) {
      throw Exception('Error fetching connection data: $e');
    }
  }
}
