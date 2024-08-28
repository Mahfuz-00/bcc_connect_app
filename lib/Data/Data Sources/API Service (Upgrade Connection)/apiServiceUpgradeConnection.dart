import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling connection upgrade operations.
class UpgradeConnectionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  UpgradeConnectionAPIService.create(this.authToken);

  /// Updates the connection with the provided details.
  ///
  /// - Parameters:
  ///   - `id`: The ID of the connection to be updated.
  ///   - `requestType`: The type of request for the update.
  ///   - `linkCapacity`: The new link capacity.
  ///   - `remark`: Additional remarks about the update.
  /// - Returns: A `Future` that completes with the JSON response from the server.
  Future<Map<String, dynamic>> updateConnection({
    required String id,
    required String requestType,
    required String linkCapacity,
    required String remark,
  }) async {
    try {
      print('API Token :: $authToken');
      final response = await http.post(
        Uri.parse('$URL/isp/update-connection'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'request_type': requestType,
          'link_capacity': linkCapacity,
          'remark': remark,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to update connection');
      }
    } catch (e) {
      throw Exception('Error updating connection: $e');
    }
  }
}
