import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for interacting with the BCC Connection API.
///
/// This class provides functionality to fetch dashboard items by sending a
/// GET request to the API.
///
/// **Actions:**
/// - [fetchDashboardItems]: Sends a GET request to retrieve dashboard items
///   and returns the response data as a map.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token required for making API requests.
class WorkOrderAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  WorkOrderAPIService.create(this.authToken);

  Future<Map<String, dynamic>> fetchWorkOrders() async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse('$baseUrl/work/order/index'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}
