import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling search filter operations.
class SearchFilterAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SearchFilterAPIService.create(this.authToken);

  /// Filters NTTN connections based on provided request data.
  ///
  /// - Parameters:
  ///   - `requestData` - A map containing the filter criteria.
  /// - Returns: A `Future` that completes with the filtered data.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
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
