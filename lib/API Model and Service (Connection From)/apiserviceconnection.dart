import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'connectionmodel.dart';

class APIServiceConnection {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  APIServiceConnection._();

  static Future<APIServiceConnection> create() async {
    var apiService = APIServiceConnection._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  APIServiceConnection() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postConnectionRequest(ConnectionRequestModel request) async {
    final String token = await authToken; // Wait for the authToken to complete
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final http.Response response = await http.post(
        Uri.parse('$URL/isp/new-connection'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Use token here
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Connection request sent successfully.');
        return jsonResponse['message'];
      } else {
        print('Failed to send connection request. Status code: ${response.statusCode}');
        return 'Failed to send connection request';
      }
    } catch (e) {
      print('Error sending connection request: $e');
      return 'Error sending connection request';
    }
  }
}
