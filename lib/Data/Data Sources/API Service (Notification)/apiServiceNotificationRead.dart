import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling notification read operations.
class NotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NotificationReadApiService.create(this.authToken);

  /// Marks notifications as read by sending a GET request to the notification read endpoint.
  ///
  /// - Returns: A `Future` that completes with a boolean value indicating success (`true`) or failure (`false`).
  /// - Throws: An [Exception] if the request fails or if an error occurs during the process.
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
