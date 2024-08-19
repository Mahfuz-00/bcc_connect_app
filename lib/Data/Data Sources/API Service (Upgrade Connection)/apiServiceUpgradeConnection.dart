import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling connection upgrade operations.
class UpgradeConnectionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  // Private constructor for singleton pattern.
  UpgradeConnectionAPIService._();

  /// Factory constructor to create an instance of `UpgradeConnectionAPIService`.
  static Future<UpgradeConnectionAPIService> create() async {
    var apiService = UpgradeConnectionAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  /// Updates the connection with the provided details.
  ///
  /// - Parameters:
  ///   - `id`: The ID of the connection to be updated.
  ///   - `requestType`: The type of request for the update.
  ///   - `linkCapacity`: The new link capacity.
  ///   - `remark`: Additional remarks about the update.
  /// - Returns: A `Future` that completes with the JSON response from the server.
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
        return data;
      } else {
        throw Exception('Failed to update connection');
      }
    } catch (e) {
      throw Exception('Error updating connection: $e');
    }
  }
}
