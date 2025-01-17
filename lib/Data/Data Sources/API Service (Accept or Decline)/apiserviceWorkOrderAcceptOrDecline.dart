import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for accepting or rejecting ISP connections through the API.
///
/// This class provides functionality to accept or reject a connection request
/// by sending a POST request to the API.
///
/// **Actions:**
/// - [acceptOrRejectConnection]: Sends a POST request to accept or reject an
///   ISP connection using the specified [type] and [ispConnectionId].
///
/// **Variables:**
/// - [URL]: The base URL for the API endpoint.
/// - [authToken]: The authentication token required for making API requests.
/// - [headers]: The HTTP headers used in the request, including the content
///   type and authorization token.
/// - [body]: The body of the request containing the [type] of action and
///   the [isp_connection_id].
class WorkOrderAcceptRejectAPIService {
  static const String URL = 'http://114.130.240.150/api';
  late final String authToken;

  WorkOrderAcceptRejectAPIService.create(this.authToken);

  Future<void> acceptOrRejectWorkOrder({
    required String type,
    required String WorkOrderNumber,
  }) async {
    final String url = '$URL/work/order/accept/or/decline';

    print('API Token :: $authToken');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final Map<String, dynamic> body = {
      "status": type,
      "work_order_number": WorkOrderNumber,
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
        if (type.toLowerCase() == 'active') {
          print('Request accepted');
        } else if (type.toLowerCase() == 'decline') {
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
