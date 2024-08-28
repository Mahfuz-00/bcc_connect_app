import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/regionmodels.dart';

/// Service class for handling region-related API operations.
class APIServiceRegion {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServiceRegion.create(this.authToken);

  /// Fetches a list of divisions from the API.
  ///
  /// - Returns: A `Future` that completes with a list of `Division` objects.
  /// - Throws: An [Exception] if the authentication token is empty or if the request fails.
  Future<List<Division>> fetchDivisions() async {
    try {
      print('API Token :: $authToken');

      final response = await http.get(
        Uri.parse('$URL/division'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'] ?? [];
          final List<Division> divisions =
              records.map((record) => Division.fromJson(record)).toList();
          print(divisions);
          return divisions;
        } else {
          throw Exception(
              'Invalid API response: missing divisions data :: ${response.body}');
        }
      } else {
        print('Failed to load all divisions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/division'));
        print('Failed to decode JSON: ${response.body}');
        print('Failed to decode JSON: ${response.statusCode}');
      } else {
        final response = await http.get(Uri.parse('$URL/division'));
        print('Failed to load a divisions: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<District>> fetchDistricts(String divisionId) async {
    print(divisionId);
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/district/$divisionId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<District> districts =
              records.map((record) => District.fromJson(record)).toList();
          print(districts);
          return districts;
        } else {
          throw Exception(
              'Invalid API response: missing district data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/district/$divisionId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http.get(Uri.parse('$URL/district/$divisionId'));
        print('Failed to load a districts: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<Upazila>> fetchUpazilas(String districtId) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/upazila/$districtId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<Upazila> upzillas =
              records.map((record) => Upazila.fromJson(record)).toList();
          print(upzillas);
          return upzillas;
        } else {
          throw Exception(
              'Invalid API response: missing Upazila data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load upazilas');
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/upazila/$districtId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http.get(Uri.parse('$URL/upazila/$districtId'));
        print('Failed to load a Upazilas: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<Union>> fetchUnions(String upazilaId) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/union/$upazilaId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        print('triggered Unions');
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<Union> Unions =
              records.map((record) => Union.fromJson(record)).toList();
          print(Unions);
          return Unions;
        } else {
          throw Exception(
              'Invalid API response: missing Union data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load unions');
      }
    } catch (e) {
      if (e is FormatException) {
        final response = await http.get(Uri.parse('$URL/union/$upazilaId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http.get(Uri.parse('$URL/union/$upazilaId'));
        print(
            'Failed to load Unions: $e, ${response.statusCode}, ${response.body}');
      }
      return [];
    }
  }

  Future<List<NTTNProvider>> fetchNTTNProviders(String unionId) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/nttn/provider/$unionId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<NTTNProvider> NTTNs =
              records.map((record) => NTTNProvider.fromJson(record)).toList();
          print(NTTNs);
          return NTTNs;
        } else {
          throw Exception(
              'Invalid API response: missing NTTNs data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load NTTN providers');
      }
    } catch (e) {
      if (e is FormatException) {
        final response =
            await http.get(Uri.parse('$URL/nttn/provider/$unionId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response =
            await http.get(Uri.parse('$URL/nttn/provider/$unionId'));
        print('Failed to load a NTTNs: $e, ${response.statusCode}');
      }
      return [];
    }
  }
}
