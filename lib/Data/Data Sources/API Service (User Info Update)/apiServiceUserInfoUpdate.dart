import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;

import '../../Models/userInfoUpdateModel.dart';

class APIServiceUpdateUser {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  APIServiceUpdateUser._();

  static Future<APIServiceUpdateUser> create() async {
    var apiService = APIServiceUpdateUser._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIServiceUpdateUser() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<String> updateUserProfile(UserProfileUpdate userData) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      // Create a POST request
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Use token here
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
          'organization': userData.organization,
          'designation': userData.designation,
          'phone': userData.phone,
          'licenseNumber': userData.licenseNumber,
        },
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Successful profile update
        var jsonResponse = jsonDecode(response.body);
        print('User profile updated successfully!');
        return jsonResponse['message'];
      } else {
        // Handle profile update failure
        print('Failed to update user profile: ${response.body}');
        return 'Failed to update user profile. Please try again.';
      }
    } catch (e) {
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Use token here
        },
        body: {
          'userId': userData.userId,
          'name': userData.name,
          'organization': userData.organization,
          'designation': userData.designation,
          'phone': userData.phone,
          'licenseNumber': userData.licenseNumber,
        },
      );
      print(response.body);
      // Handle any exceptions
      print('Error occurred while updating user profile: $e');
      return 'Failed to update user profile. Please try again.';
    }
  }
}
