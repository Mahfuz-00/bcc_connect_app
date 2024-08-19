import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/userInfoUpdateModel.dart';

/// Service class for handling user profile updates.
class APIServiceUpdateUser {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  // Private constructor for singleton pattern.
  APIServiceUpdateUser._();

  /// Factory constructor to create an instance of `APIServiceUpdateUser`.
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

  /// Loads the authentication token from shared preferences.
  ///
  /// - Returns: A future that completes with the authentication token.
  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  /// Updates the user profile with the provided data.
  ///
  /// - Parameters:
  ///   - `userData`: An instance of `UserProfileUpdate` containing user profile data.
  /// - Returns: A `Future` that completes with a message from the server.
  Future<String> updateUserProfile(UserProfileUpdate userData) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
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

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('User profile updated successfully!');
        return jsonResponse['message'];
      } else {
        print('Failed to update user profile: ${response.body}');
        return 'Failed to update user profile. Please try again.';
      }
    } catch (e) {
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
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
      print('Error occurred while updating user profile: $e');
      return 'Failed to update user profile. Please try again.';
    }
  }
}
