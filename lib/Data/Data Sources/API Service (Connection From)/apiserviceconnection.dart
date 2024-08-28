import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/connectionmodel.dart';

/// Service class for handling API requests related to connection Form.
class APIServiceConnection {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServiceConnection.create(this.authToken);

  /// Sends a new connection request to the API.
  ///
  /// - Parameters:
  ///   - [request]: An instance of `ConnectionRequestModel` containing the request data.
  ///
  /// - Returns: A future that completes with a string message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
  Future<String> postConnectionRequest(ConnectionRequestModel request) async {
    try {
      print('API Token :: $authToken');

      final http.Response response = await http.post(
        Uri.parse('$URL/isp/new-connection'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Connection request sent successfully.');
        return jsonResponse['message'];
      } else {
        print(
            'Failed to send connection request. Status code: ${response.statusCode}');
        return 'Failed to send connection request';
      }
    } catch (e) {
      print('Error sending connection request: $e');
      return 'Error sending connection request';
    }
  }
}
