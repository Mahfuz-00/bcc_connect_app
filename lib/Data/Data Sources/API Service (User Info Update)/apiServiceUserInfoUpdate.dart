import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/userInfoUpdateModel.dart';

/// A service class for updating user profile information via an API.
///
/// This class is responsible for sending a request to update user details
/// such as name, organization, designation, phone, and license number.
///
/// **Variables:**
/// - [authToken]: The authentication token used for API requests.
/// - [URL]: The endpoint URL for updating user profiles.
///
/// **Actions:**
/// - [updateUserProfile]: Sends a POST request to update the user's profile
///   using the provided [userData], which includes [userId], [name],
///   [organization], [designation], [phone], and [licenseNumber].
class UpdateUserAPIService {
  late final String authToken;
  String URL = "https://bcc.touchandsolve.com/api/user/profile/update";

  UpdateUserAPIService.create(this.authToken);

  Future<String> updateUserProfile(UserProfileUpdateModel userData) async {
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
