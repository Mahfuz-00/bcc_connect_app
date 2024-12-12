import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/registermodels.dart';

/// A service class for handling user registration through API requests.
///
/// This class is responsible for sending a registration request, including
/// user details and an optional profile image, to the server.
///
/// **Actions:**
/// - [register]: Sends a POST request to register a new user with the provided
///   [registerRequestModel] and an optional [imageFile]. It returns a
///   [String] message indicating the result of the registration process.
///
/// **Variables:**
/// - [url]: The endpoint URL for the registration API.
class UserRegistrationAPIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['app_name'] = 'bcc';
      request.fields['full_name'] = registerRequestModel.fullName;
      request.fields['organization'] = registerRequestModel.organization;
      request.fields['designation'] = registerRequestModel.designation;
      request.fields['address'] = registerRequestModel.organiazationAddress;
      request.fields['email'] = registerRequestModel.email;
      request.fields['phone'] = registerRequestModel.phone;
      request.fields['password'] = registerRequestModel.password;
      request.fields['password_confirmation'] =
          registerRequestModel.confirmPassword;
      request.fields['isp_user_type'] = registerRequestModel.userType;
      request.fields['license_number'] = registerRequestModel.licenseNumber;
      request.fields['type_of_organization'] = registerRequestModel.organiazationType;

      if(imageFile != null){
        var imageStream = http.ByteStream(imageFile!.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('photo', imageStream, length,
            filename: imageFile.path.split('/').last);

        request.files.add(multipartFile);
      }


      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('User registered successfully!');
        print(jsonResponse['message']);
        return jsonResponse['message'];
      } else {
        //print('Failed to register user: ${await response.stream.bytesToString()}');
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        var jsonResponse = jsonDecode(responseBody);
        print('Failed to register user: $jsonResponse');

        if (jsonResponse.containsKey('errors')) {
          var errors = jsonResponse['errors'];
          print(errors);
          var emailError =
              errors.containsKey('email') ? errors['email'][0] : '';
          var phoneError =
              errors.containsKey('phone') ? errors['phone'][0] : '';

          var errorMessage = '';
          if (emailError.isNotEmpty) errorMessage = emailError;
          if (phoneError.isNotEmpty) errorMessage = phoneError;

          print(errorMessage);
          return errorMessage;
        } else {
          print('Failed to register user: $responseBody');
          return 'Failed to register user. Please try again.';
        }
      }
    } catch (e) {
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
