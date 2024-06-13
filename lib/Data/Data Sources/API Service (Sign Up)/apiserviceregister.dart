import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../Models/registermodels.dart';

class APIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add user data fields to the request
      request.fields['app_name'] = 'bcc';
      request.fields['full_name'] = registerRequestModel.fullName;
      request.fields['organization'] = registerRequestModel.organization;
      request.fields['designation'] = registerRequestModel.designation;
      request.fields['email'] = registerRequestModel.email;
      request.fields['phone'] = registerRequestModel.phone;
      request.fields['password'] = registerRequestModel.password;
      request.fields['password_confirmation'] = registerRequestModel.confirmPassword;
      request.fields['isp_user_type'] = registerRequestModel.userType;
      request.fields['license_number'] = registerRequestModel.licenseNumber;

      // Add the image file to the request
      var imageStream = http.ByteStream(imageFile!.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: imageFile.path.split('/').last);

      request.files.add(multipartFile);

      // Send the request and await the response
      var response = await request.send();

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Successful registration
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('User registered successfully!');
        return jsonResponse['message'];
      } else {
        // Handle registration failure
        print('Failed to register user: ${await response.stream.bytesToString()}');
        return 'Failed to register user. Please try again.';
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
