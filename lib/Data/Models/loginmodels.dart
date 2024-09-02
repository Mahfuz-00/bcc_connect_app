/// Represents the response model for a login request.
///
/// This class encapsulates the data returned from the server upon
/// a successful login attempt.
///
/// **Variables:**
/// - [token]: A String containing the authentication token provided by the server.
/// - [error]: A String containing any error message returned by the server, if applicable.
/// - [userType]: A String indicating the type of user (e.g., admin, regular user).
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
      token: json["token"] ?? "", // Defaults to an empty string if null.
      error: json["error"] ?? "", // Defaults to an empty string if null.
      userType: json["userType"] ?? "", // Defaults to an empty string if null.
    );
  }
}

/// Represents the request model for a login operation.
///
/// This class is used to encapsulate the credentials required for
/// a login request to the server.
///
/// **Variables:**
/// - [Email]: A String representing the user's email address used for login.
/// - [Password]: A String representing the user's password used for authentication.
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
