import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/searchmodel.dart';

/// Service class for handling search region operations.
class APIServiceSearchRegion {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIServiceSearchRegion.create(this.authToken);

  /// Fetches a list of divisions from the API.
  ///
  /// - Returns: A `Future` that completes with a list of `DivisionSearch` objects.
  /// - Throws: An [Exception] if the request fails or if the response is invalid.
  Future<List<DivisionSearch>> fetchDivisions() async {
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
          //print('Record:: $records');
          final List<DivisionSearch> divisions =
              records.map((record) => DivisionSearch.fromJson(record)).toList();
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

  /// Fetches a list of districts for a given division.
  ///
  /// - Parameters:
  ///   - `divisionId` - The ID of the division.
  /// - Returns: A `Future` that completes with a list of `DistrictSearch` objects.
  /// - Throws: An [Exception] if the request fails or if the response is invalid.
  Future<List<DistrictSearch>> fetchDistricts(String divisionId) async {
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
          final List<DistrictSearch> districts =
              records.map((record) => DistrictSearch.fromJson(record)).toList();
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

  /// Fetches a list of upazilas for a given district.
  ///
  /// - Parameters:
  ///   - `districtId` - The ID of the district.
  /// - Returns: A `Future` that completes with a list of `UpazilaSearch` objects.
  /// - Throws: An [Exception] if the request fails or if the response is invalid.
  Future<List<UpazilaSearch>> fetchUpazilas(String districtId) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/upazila/$districtId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<UpazilaSearch> upzillas =
              records.map((record) => UpazilaSearch.fromJson(record)).toList();
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

  /// Fetches a list of unions for a given upazila.
  ///
  /// - Parameters:
  ///   - `upazilaId` - The ID of the upazila.
  /// - Returns: A `Future` that completes with a list of `UnionSearch` objects.
  /// - Throws: An [Exception] if the request fails or if the response is invalid.
  Future<List<UnionSearch>> fetchUnions(String upazilaId) async {
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
          final List<UnionSearch> Unions =
              records.map((record) => UnionSearch.fromJson(record)).toList();
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

  /// Fetches a list of NTTN providers for a given union.
  ///
  /// - Parameters:
  ///   - `unionId` - The ID of the union.
  /// - Returns: A `Future` that completes with a list of `NTTNProviderResult` objects.
  /// - Throws: An [Exception] if the request fails or if the response is invalid.
  Future<List<NTTNProviderResult>> fetchNTTNProviders(String unionId) async {
    try {
      print('API Token :: $authToken');
      final response = await http.get(Uri.parse('$URL/nttn/provider/$unionId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<NTTNProviderResult> NTTNs = records
              .map((record) => NTTNProviderResult.fromJson(record))
              .toList();
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
