class LoginResponseModel {
  late final String token;
  late final String error;
  late final String userType;

  LoginResponseModel({this.token = "", this.error = "", this.userType = ""});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      /*Token: json['token'] != null ? json['token'] : "",
        Error: json['error'] != null ? json['error'] : ""*/
      token: json["token"] ?? "",
      error: json["error"] ?? "",
      userType: json["userType"] ?? "",
    );
  }
}

class LoginRequestmodel {
  late String Email;
  late String Password;

  LoginRequestmodel({
    required this.Email,
    required this.Password
  });

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'email': Email,
      'password': Password
    };

    return map;
  }
}
