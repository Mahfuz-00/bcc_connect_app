class UserProfileFull {
  final int id;
  final String name;
  final String organization;
  final String designation;
  final String phone;
  final String license;
  final String ISPuserType;
  final String email;
  final String photo;

  UserProfileFull({
    required this.id,
    required this.name,
    required this.organization,
    required this.designation,
    required this.phone,
    required this.license,
    required this.ISPuserType,
    required this.email,
    required this.photo,
  });

  factory UserProfileFull.fromJson(Map<String, dynamic> json) {
    return UserProfileFull(
      id: json['userId'],
      name: json['name'],
      organization: json['organization'],
      designation: json['designation'],
      phone: json['phone'],
      license: json['licenseNumber'],
      ISPuserType: json['ispUserType'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}