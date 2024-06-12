class RegisterResponseModel {
  String message;
  String status;

  RegisterResponseModel({required this.message, required this.status});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message'], status: '');
    //return RegisterResponseModel(message: json['message'], status: json['status']);
  }
}

class RegisterRequestmodel {
  late String fullName;
  late String organization;
  late String designation;
  late String email;
  late String phone;
  late String password;
  late String confirmPassword;
  late String userType;
  late String licenseNumber;

  RegisterRequestmodel({
    required this.fullName,
    required this.organization,
    required this.designation,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.userType,
    required this.licenseNumber,
  });

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {
      'full_name': fullName,
      'organization': organization,
      'designation': designation,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': confirmPassword,
      'isp_user_type': userType,
      'license_number': licenseNumber,
    };

    return map;
  }
}