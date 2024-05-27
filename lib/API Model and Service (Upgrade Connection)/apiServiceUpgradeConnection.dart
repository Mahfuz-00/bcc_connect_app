import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpgradeConnectionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  UpgradeConnectionAPIService._();

  static Future<UpgradeConnectionAPIService> create() async {
    var apiService = UpgradeConnectionAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> updateConnection({
    required String id,
    required String requestType,
    required String linkCapacity,
    required String remark,
  }) async {
    final String token = authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.post(
        Uri.parse('$URL/isp/update-connection'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'request_type': requestType,
          'link_capacity': linkCapacity,
          'remark': remark,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data; // Return the JSON body directly
      } else {
        throw Exception('Failed to update connection');
      }
    } catch (e) {
      throw Exception('Error updating connection: $e');
    }
  }
}
