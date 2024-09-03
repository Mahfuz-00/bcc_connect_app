import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class for fetching full data related to ISP connections.
///
/// This class is responsible for retrieving detailed data for ISP connections
/// from the API.
///
/// **Actions:**
/// - [fetchFullData]: Sends a GET request to fetch full data from the provided
///   [url] and returns the data as a map.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
class ISPConnectionFullAPIService {
  late final String authToken;

  ISPConnectionFullAPIService.create(this.authToken);

  Future<Map<String, dynamic>> fetchFullData(String url) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'},
      );

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
