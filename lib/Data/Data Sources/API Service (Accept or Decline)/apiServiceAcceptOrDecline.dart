import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling connection acceptance and rejection requests.
class ConnectionAcceptRejectAPIService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ConnectionAcceptRejectAPIService.create(this.authToken);

  /// Accepts or rejects a connection based on the provided type and connection ID.
  ///
  /// - [type]: The action to be performed ('accepted' or 'rejected').
  /// - [ispConnectionId]: The ID of the ISP connection to be processed.
  ///
  /// - Returns: A future that completes when the request is processed.
  Future<void> acceptOrRejectConnection({
    required String type,
    required int ispConnectionId,
  }) async {
    final String url = '$URL/connection/accept/or/reject';

    print('API Token :: $authToken');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final Map<String, dynamic> body = {
      "type": type,
      "isp_connection_id": ispConnectionId,
    };

    print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        // Request successful
        print('Connection accepted/rejected successfully');
        if (type.toLowerCase() == 'accepted') {
          print('Request accepted');
        } else if (type.toLowerCase() == 'rejected') {
          print('Request declined');
        }
      } else {
        print(
            'Failed to accept/reject connection. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting/rejecting connection: $e');
    }
  }
}
