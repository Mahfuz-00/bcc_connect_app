import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for marking notifications as read via an API request.
///
/// This class is responsible for sending a request to the server to mark a notification as read. It uses an
/// [authToken] to authenticate the API request.
///
/// **Variables:**
/// - [authToken]: The authentication token required for authorization.
/// - [URL]: The base URL of the API endpoint.
///
/// **Actions:**
/// - [create]: A constructor that initializes the [NotificationReadApiService] class with the [authToken].
/// - [readNotification]: Sends a GET request to the API to mark the notification as read.
class NotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NotificationReadApiService.create(this.authToken);

  Future<bool> readNotification() async {
    try {
      print('API Token :: $authToken');
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
