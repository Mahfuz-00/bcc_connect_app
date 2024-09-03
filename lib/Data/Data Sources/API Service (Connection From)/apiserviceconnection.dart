import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/connectionmodel.dart';

/// A service class for handling connection requests to the API.
///
/// This class is responsible for sending new connection requests to the ISP.
///
/// **Actions:**
/// - [postConnectionRequest]: Sends a POST request with the [ConnectionRequestModel]
///   to the API and returns a message indicating the success or failure of the request.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class ConnectionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ConnectionAPIService.create(this.authToken);

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
