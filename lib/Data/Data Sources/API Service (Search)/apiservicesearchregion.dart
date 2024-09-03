import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/searchmodel.dart';

/// A service class for managing API requests related to geographical regions.
///
/// This class is responsible for fetching data related to divisions, districts,
/// upazilas, unions, and NTTN providers through GET requests to the API.
///
/// **Actions:**
/// - [fetchDivisions]: Sends a GET request to retrieve a list of divisions
///   and returns them as a [List<DivisionSearch>].
/// - [fetchDistricts]: Sends a GET request to retrieve a list of districts
///   for a given [divisionId] and returns them as a [List<DistrictSearch>].
/// - [fetchUpazilas]: Sends a GET request to retrieve a list of upazilas
///   for a given [districtId] and returns them as a [List<UpazilaSearch>].
/// - [fetchUnions]: Sends a GET request to retrieve a list of unions for a
///   given [upazilaId] and returns them as a [List<UnionSearch>].
/// - [fetchNTTNProviders]: Sends a GET request to retrieve a list of NTTN
///   providers for a given [unionId] and returns them as a
///   [List<NTTNProviderResult>].
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for API requests.
class SearchRegionAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SearchRegionAPIService.create(this.authToken);

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
