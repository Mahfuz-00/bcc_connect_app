import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/imageUpdateModel.dart';

/// A service class for updating the user's profile picture via an API.
///
/// This class is responsible for uploading the user's profile photo to the server.
///
/// **Variables:**
/// - [URL]: The API endpoint for updating the profile picture.
/// - [authToken]: The authentication token used for API requests.
///
/// **Actions:**
/// - [updateProfilePicture]: Sends a POST request to update
/// the user's profile picture using the provided [image] file.
class ProfilePictureUpdateAPIService {
  static const String URL =
      'http://114.130.240.150/api/user/profile/photo/update';
  late final String authToken;

  ProfilePictureUpdateAPIService.create(this.authToken);

  Future<ProfilePictureUpdateResponse> updateProfilePicture(
      {required File image}) async {
    try {
      print('API Token :: $authToken');
      var request = http.MultipartRequest('POST', Uri.parse(URL));
      request.headers['Authorization'] = 'Bearer $authToken';
      request.headers['Accept'] = 'application/json';
      print(image);
      var imageStream = http.ByteStream(image!.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: image.path.split('/').last);
      print(multipartFile);
      request.files.add(multipartFile);
      //request.files.add(await http.MultipartFile.fromPath('photo', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> json = jsonDecode(responseBody);
        print(json);
        return ProfilePictureUpdateResponse.fromJson(json);
      } else {
        String responseBody = await response.stream.bytesToString();
        print(response.statusCode);
        print(responseBody);
        throw Exception(
            'Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}
