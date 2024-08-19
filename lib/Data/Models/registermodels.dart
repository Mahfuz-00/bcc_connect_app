/// Represents the response model for user registration.
class RegisterResponseModel {
  /// Message from the server about the registration status.
  String message;

  /// Status of the registration process.
  String status;

  /// Constructor for `RegisterResponseModel`.
  ///
  /// - [message]: Message from the server about the registration status.
  /// - [status]: Status of the registration process.
  RegisterResponseModel({required this.message, required this.status});

  /// Factory constructor to create a `RegisterResponseModel` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the registration response.
  /// - Returns: A `RegisterResponseModel` instance with `message` and `status` populated from the JSON map.
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(message: json['message'], status: '');
    //return RegisterResponseModel(message: json['message'], status: json['status']);
  }
}

/// Represents the request model for user registration.
class RegisterRequestmodel {
  /// Full name of the user registering.
  late String fullName;

  /// Organization the user is associated with.
  late String organization;

  /// Designation of the user within the organization.
  late String designation;

  /// Email address of the user.
  late String email;

  /// Phone number of the user.
  late String phone;

  /// Password chosen by the user for registration.
  late String password;

  /// Confirmation of the password to ensure they match.
  late String confirmPassword;

  /// Type of user.
  late String userType;

  /// License number of the user (if applicable).
  late String licenseNumber;

  /// Constructor for `RegisterRequestModel`.
  ///
  /// - [fullName]: Full name of the user registering.
  /// - [organization]: Organization the user is associated with.
  /// - [designation]: Designation of the user within the organization.
  /// - [email]: Email address of the user.
  /// - [phone]: Phone number of the user.
  /// - [password]: Password chosen by the user for registration.
  /// - [confirmPassword]: Confirmation of the password to ensure they match.
  /// - [userType]: Type of user (e.g., admin, member).
  /// - [licenseNumber]: License number of the user (if applicable).
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

  /// Converts the `RegisterRequestModel` instance to a JSON map.
  ///
  /// - Returns: A map containing the JSON representation of the registration request.
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
