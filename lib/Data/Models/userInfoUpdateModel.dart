class UserProfileUpdate {
  final String userId;
  final String name;
  final String organization;
  final String designation;
  final String phone;
  final String licenseNumber;

  UserProfileUpdate({
    required this.userId,
    required this.name,
    required this.organization,
    required this.designation,
    required this.phone,
    required this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'organization': organization,
      'designation': designation,
      'phone': phone,
      'licenseNumber': licenseNumber,
    };
  }
}
