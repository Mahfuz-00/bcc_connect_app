import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/imageUpdateModel.dart';



class APIProfilePictureUpdate {
  static const String URL =
      'https://bcc.touchandsolve.com/api/user/profile/photo/update';
  late final String authToken;

  APIProfilePictureUpdate._();

  static Future<APIProfilePictureUpdate> create() async {
    var apiService = APIProfilePictureUpdate._();
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

  Future<ProfilePictureUpdateResponse> updateProfilePicture({required File image}) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }
      var request = http.MultipartRequest('POST', Uri.parse(URL));
      request.headers['Authorization'] = 'Bearer $token';
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
