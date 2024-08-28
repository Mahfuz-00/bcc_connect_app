import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/userInfoUpdateModel.dart';

/// Service class for handling user profile updates.
class APIServiceUpdateUser {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  APIServiceUpdateUser.create(this.authToken);

  /// Updates the user profile with the provided data.
  ///
  /// - Parameters:
  ///   - `userData`: An instance of `UserProfileUpdate` containing user profile data.
  /// - Returns: A `Future` that completes with a message from the server.
  Future<String> updateUserProfile(UserProfileUpdate userData) async {
    try {
      print('API Token :: $authToken');
      var response = await http.post(
        Uri.parse(URL),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken'
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
          'Authorization': 'Bearer $authToken'
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
