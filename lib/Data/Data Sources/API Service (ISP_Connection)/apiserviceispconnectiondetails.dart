import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for fetching ISP dashboard data from the API.
///
/// This class is responsible for retrieving dashboard data for ISP connections.
///
/// **Actions:**
/// - [fetchDashboardData]: Sends a GET request to fetch the dashboard data
///   and returns the data as a map.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class ISPConnectionAPIService {
  final String URL = 'http://114.130.240.150/api';
  late final String authToken;

  ISPConnectionAPIService.create(this.authToken);

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$URL/dashboard'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}
