import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for managing search filter API requests.
///
/// This class is responsible for filtering NTTN connection data
/// through a POST request to the API.
///
/// **Actions:**
/// - [filterNTTNConnection]: Sends a POST request with [requestData]
///   to filter NTTN connections and returns the response data as a
///   [Map<String, dynamic>].
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class SearchFilterAPIService {
  final String baseUrl = 'http://114.130.240.150/api';
  late final String authToken;

  SearchFilterAPIService.create(this.authToken);

  Future<Map<String, dynamic>> filterNTTNConnection(Map<String, dynamic> requestData) async {
    print(requestData);
    try {
      print('API Token :: $authToken');
      final response = await http.post(
        Uri.parse('$baseUrl/filter/nttn/connection'),
        headers: {'Authorization': 'Bearer $authToken'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to filter NTTN connection: ${response.reasonPhrase},  ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering NTTN connection: $e');
    }
  }
}
