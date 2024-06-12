import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionAcceptRejectAPIService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ConnectionAcceptRejectAPIService._();

  static Future<ConnectionAcceptRejectAPIService> create() async {
    var apiService = ConnectionAcceptRejectAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }


  Future<void> acceptOrRejectConnection({required String type, required int ispConnectionId,}) async {
    final String url = '$URL/connection/accept/or/reject';

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
        // Request failed
        print('Failed to accept/reject connection. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error accepting/rejecting connection: $e');
    }
  }
}
