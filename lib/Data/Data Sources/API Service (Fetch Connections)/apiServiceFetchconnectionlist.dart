import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for fetching connection data from the API.
///
/// This class is responsible for retrieving a list of connections for a specific user.
///
/// **Actions:**
/// - [fetchConnectionData]: Sends a GET request to fetch connection data for the
///   specified [userId] and returns the data as a map.
///
/// **Variables:**
/// - [baseURL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class FetchedConnectionListAPIService {
  final String baseURL = 'http://114.130.240.150/api';
  late final String authToken;

  FetchedConnectionListAPIService.create(this.authToken);

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
