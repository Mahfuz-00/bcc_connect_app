import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling notification read operations.
class NotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  NotificationReadApiService._();

  /// Creates and initializes a new instance of `NotificationReadApiService`.
  ///
  /// - Returns: A `Future` that completes with an instance of `NotificationReadApiService`.
  static Future<NotificationReadApiService> create() async {
    var apiService = NotificationReadApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  NotificationReadApiService() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }*/

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
    //return token;
  }

  /// Marks notifications as read by sending a GET request to the notification read endpoint.
  ///
  /// - Returns: A `Future` that completes with a boolean value indicating success (`true`) or failure (`false`).
  /// - Throws: An [Exception] if the request fails or if an error occurs during the process.
  Future<bool> readNotification() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/notification/read'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Notification Read!!');
        return true;
      } else {
        print(response.body);
        print('Failed to read Notification: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      print(response.body);
      print('Exception While Reading Notification: $e');
      return false;
    }
  }
}
