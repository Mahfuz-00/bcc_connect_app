import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchFilterAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SearchFilterAPIService._();

  static Future<SearchFilterAPIService> create() async {
    var apiService = SearchFilterAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  SearchFilterAPIService() {
    _loadAuthToken();
    print('triggered');
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> filterNTTNConnection(Map<String, dynamic> requestData) async {
    print(requestData);
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print('Authen:: $authToken');
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.post(
        Uri.parse('$baseUrl/filter/nttn/connection'),
        headers: {'Authorization': 'Bearer $authToken'},
        body: requestData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to filter NTTN connection: ${response.reasonPhrase},  ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering NTTN connection: $e');
    }
  }
}
