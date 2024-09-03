import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for upgrading ISP connection requests through the API.
///
/// This class handles the process of updating an existing ISP connection
/// by sending the necessary information to the server.
///
/// **Actions:**
/// - [updateConnection]: Sends a POST request to update a connection with the
///   specified [id], [requestType], [linkCapacity], and [remark]. It returns
///   a [Map<String, dynamic>] containing the response data.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authorization token required for API access.
class UpgradeConnectionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  UpgradeConnectionAPIService.create(this.authToken);

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
