import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../Models/loginmodels.dart';

/// Service class for handling login operations.
class APIService {
  /// Logs in a user by sending a POST request to the login endpoint.
  ///
  /// - Parameter loginRequestModel: An instance of `LoginRequestmodel` containing login credentials.
  /// - Returns: A `Future` that completes with an instance of `LoginResponseModel` on success, or `null` if the request fails.
  /// - Throws: An [Exception] if the request fails or if an error occurs during the login process.
  Future<LoginResponseModel?> login(LoginRequestmodel loginRequestModel) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/login";

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
