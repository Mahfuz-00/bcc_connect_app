/// The `LoginResponseModel` class represents the response received after a user login attempt.
/// It includes the authentication token, any error messages, and the type of user.
class LoginResponseModel {
  /// The authentication token provided upon successful login.
  late final String token;

  /// An error message if the login attempt fails or encounters issues.
  late final String error;

  /// The type of user (e.g., BCC Admin, NTTN Admin, ISP User) authenticated by the login process.
  late final String userType;

  /// Constructor for `LoginResponseModel`.
  ///
  /// - [token]: The authentication token. Defaults to an empty string.
  /// - [error]: The error message, if any. Defaults to an empty string.
  /// - [userType]: The type of user. Defaults to an empty string.
  LoginResponseModel({this.token = "", this.error = "", this.userType = ""});

  /// Factory constructor that creates a `LoginResponseModel` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data for the login response.
  /// - Returns: A `LoginResponseModel` instance with fields populated from the JSON map.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      /*Token: json['token'] != null ? json['token'] : "",
        Error: json['error'] != null ? json['error'] : ""*/
      token: json["token"] ?? "", // Defaults to an empty string if null.
      error: json["error"] ?? "", // Defaults to an empty string if null.
      userType: json["userType"] ?? "", // Defaults to an empty string if null.
    );
  }
}

/// The `LoginRequestModel` class represents the data required to make a login request.
/// It includes the user's email and password.
class LoginRequestmodel {
  /// The email address of the user attempting to log in.
  late String Email;

  /// The password of the user attempting to log in.
  late String Password;

  /// Constructor for `LoginRequestModel`.
  ///
  /// - [Email]: The email address used for login.
  /// - [Password]: The password used for login.
  LoginRequestmodel({required this.Email, required this.Password});

  /// Converts the `LoginRequestModel` instance to a JSON map.
  ///
  /// - Returns: A map representing the login request data.
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'email': Email, // User's email address.
      'password': Password // User's password.
    };

    return map;
  }
}
