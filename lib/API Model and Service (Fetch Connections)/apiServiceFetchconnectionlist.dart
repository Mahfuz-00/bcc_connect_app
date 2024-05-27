import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'ispconnectiondetailsmodel.dart';

class FetchedConnectionListAPIService {
  final String baseURL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  FetchedConnectionListAPIService._();

  static Future<FetchedConnectionListAPIService> create() async {
    var apiService = FetchedConnectionListAPIService._();
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

  Future<Map<String, dynamic>> fetchConnectionData(String userId) async {
    try {
      if (authToken.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$baseURL/bcc/getconnections/$userId'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data; // Return the JSON body directly
      } else {
        throw Exception('Failed to load connection data');
      }
    } catch (e) {
      throw Exception('Error fetching connection data: $e');
    }
  }
}
