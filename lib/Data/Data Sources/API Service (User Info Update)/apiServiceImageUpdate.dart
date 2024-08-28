import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../Models/imageUpdateModel.dart';

/// Service class for handling profile picture updates.
class APIProfilePictureUpdate {
  static const String URL =
      'https://bcc.touchandsolve.com/api/user/profile/photo/update';
  late final String authToken;

  APIProfilePictureUpdate.create(this.authToken);

  /// Updates the profile picture with the provided image file.
  ///
  /// - Parameters:
  ///   - `image`: The image file to upload.
  /// - Returns: A `Future` that completes with a `ProfilePictureUpdateResponse` containing the server response.
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
