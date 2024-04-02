class LoginResponseModel {
  late final String Token;
  late final String Error;

  LoginResponseModel({this.Token = "", this.Error = ""});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      /*Token: json['token'] != null ? json['token'] : "",
        Error: json['error'] != null ? json['error'] : ""*/
        Token: json["token"] ?? "",
        Error: json["error"] ?? "");
  }
}

class LoginRequestmodel {
  late String Email;
  late String Password;

  LoginRequestmodel({required this.Email, required this.Password});

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      "uname": Email.trim(),
      "passwd": Password.trim()
    };

    return map;
  }
}
