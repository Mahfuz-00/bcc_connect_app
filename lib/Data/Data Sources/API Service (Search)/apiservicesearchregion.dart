import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/searchmodel.dart';


class APIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  APIService._();

  static Future<APIService> create() async {
    var apiService = APIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  APIService() {
    _loadAuthToken();
    print('triggered');
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

/*  void setAuthToken(String token) {
    authToken = token;
  }*/

  Future<List<DivisionSearch>> fetchDivisions() async {
    try {
      if (authToken.isEmpty) {
        print('Authen:: $authToken');
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      print('Token:: $authToken');

      final response = await http.get(
        Uri.parse('$URL/division'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        /*print(data);
        print(data.runtimeType);*/
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
        final response = await http
            .get(Uri.parse('$URL/division'));
        print('Failed to decode JSON: ${response.body}');
        print('Failed to decode JSON: ${response.statusCode}');
      } else {
        final response = await http
            .get(Uri.parse('$URL/division'));
        print('Failed to load a divisions: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<DistrictSearch>> fetchDistricts(String divisionId) async {
    print(divisionId);
    try {
      if (authToken.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.get(Uri.parse('$URL/district/$divisionId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<DistrictSearch> districts =  records.map((record) => DistrictSearch.fromJson(record)).toList();
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
        final response = await http
            .get(Uri.parse('$URL/district/$divisionId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http
            .get(Uri.parse('$URL/district/$divisionId'));
        print('Failed to load a districts: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<UpazilaSearch>> fetchUpazilas(String districtId) async {
    try{
      if (authToken.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.get(Uri.parse('$URL/upazila/$districtId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<UpazilaSearch> upzillas =  records.map((record) => UpazilaSearch.fromJson(record)).toList();
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
        final response = await http
            .get(Uri.parse('$URL/upazila/$districtId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http
            .get(Uri.parse('$URL/upazila/$districtId'));
        print('Failed to load a Upazilas: $e, ${response.statusCode}');
      }
      return [];
    }
  }

  Future<List<UnionSearch>> fetchUnions(String upazilaId) async {
    try{
      if (authToken.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.get(Uri.parse('$URL/union/$upazilaId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        print('triggered Unions');
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<UnionSearch> Unions =  records.map((record) => UnionSearch.fromJson(record)).toList();
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
        final response = await http
            .get(Uri.parse('$URL/union/$upazilaId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http
            .get(Uri.parse('$URL/union/$upazilaId'));
        print('Failed to load Unions: $e, ${response.statusCode}, ${response.body}');
      }
      return [];
    }
  }

  Future<List<NTTNProviderResult>> fetchNTTNProviders(String unionId) async {
    try{
      if (authToken.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();

        if (authToken.isEmpty) {
          throw Exception('Authentication token is empty.');
        }
      }
      final response = await http.get(Uri.parse('$URL/nttn/provider/$unionId'),
          headers: {'Authorization': 'Bearer $authToken'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data != null && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          print('Record:: $records');
          final List<NTTNProviderResult> NTTNs =  records.map((record) => NTTNProviderResult.fromJson(record)).toList();
          print(NTTNs);
          return NTTNs;
        } else {
          throw Exception(
              'Invalid API response: missing NTTNs data :: ${response.body}');
        }
      } else {
        throw Exception('Failed to load NTTN providers');
      }
    } catch(e) {
      if (e is FormatException) {
        final response = await http
            .get(Uri.parse('$URL/nttn/provider/$unionId'));
        print('Failed to decode JSON: ${response.body}');
      } else {
        final response = await http
            .get(Uri.parse('$URL/nttn/provider/$unionId'));
        print('Failed to load a NTTNs: $e, ${response.statusCode}');
      }
      return [];
    }
  }
}