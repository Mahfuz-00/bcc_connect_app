class RegisterResponseModel {
  String message;

  RegisterResponseModel({required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message']);
  }
}

class RegisterRequestmodel {
  late String Email;
  late String Password;

  RegisterRequestmodel({required this.Email, required this.Password});

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      "email": Email.trim(),
      "passwd": Password.trim()
    };

    return map;
  }
}