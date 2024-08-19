import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/connectionmodel.dart';

/// Service class for handling API requests related to connection Form.
class APIServiceConnection {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  // Private constructor for singleton pattern.
  APIServiceConnection._();

  /// Creates an instance of `APIServiceConnection` and loads the auth token.
  ///
  /// - Returns: A future that completes with an instance of `APIServiceConnection`.
  static Future<APIServiceConnection> create() async {
    var apiService = APIServiceConnection._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  /// Initializes `authToken` by loading it from shared preferences.
  APIServiceConnection() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  /// Sends a new connection request to the API.
  ///
  /// - Parameters:
  ///   - [request]: An instance of `ConnectionRequestModel` containing the request data.
  ///
  /// - Returns: A future that completes with a string message indicating success or failure.
  ///
  /// - Throws: An [Exception] if the token is empty or if the request fails.
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
          'Authorization': 'Bearer $token'
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
