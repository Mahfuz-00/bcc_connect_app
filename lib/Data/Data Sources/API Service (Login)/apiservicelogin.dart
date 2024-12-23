import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../Models/loginmodels.dart';

/// A service class responsible for handling the login functionality.
///
/// This class provides methods to send login requests to the API and
/// process the response. It uses the [LoginRequestmodel] for the request body
/// and returns a [LoginResponseModel] on successful login.
///
/// **Variables:**
/// - [url]: The API endpoint for the login request.
///
/// **Actions:**
/// - [login]: Sends a POST request to the API with the user's login details.
///   If the login is successful, it returns a [LoginResponseModel]. If not, it throws an [Exception].
class LoginAPIService {
  Future<LoginResponseModel?> login(LoginRequestmodel loginRequestModel) async {
    try {
      String url = "http://114.130.240.150/api/login";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequestModel.toJSON()),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("Error:: ${jsonResponse}");
        return LoginResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while logging in: $e');
    }
  }
}
