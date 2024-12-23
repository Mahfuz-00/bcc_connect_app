import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/package.dart';

/// A service class for managing package-related API requests.
///
/// This class is responsible for fetching data related to packages from the API.
///
/// **Actions:**
/// - [fetchPackages]: Sends a GET request to retrieve a list of packages
///   and returns it as a list of [Package] objects.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class PackageAPIService {
  final String URL = 'http://114.130.240.150/api';
  late final String authToken;

  PackageAPIService.create(this.authToken);

  /// Fetches the list of packages from the API.
  ///
  /// Returns a list of [Package] objects if the request is successful,
  /// otherwise returns an empty list.
  Future<List<Package>> fetchPackages() async {
    try {
      print('API Token :: $authToken');

      final response = await http.get(
        Uri.parse('$URL/all/service'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data);

        // Check if data contains 'records' and parse it to a list of Packages
        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'] ?? [];
          final List<Package> packages =
          records.map((record) => Package.fromJson(record)).toList();

          print(packages);
          return packages;
        } else {
          throw Exception('Invalid API response: missing packages data.');
        }
      } else {
        print('Failed to load packages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching packages: $e');
      return [];
    }
  }
}
