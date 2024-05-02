class UserProfile {
  final String name;
  final String organization;
  final String photo;

  UserProfile({
    required this.name,
    required this.organization,
    required this.photo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      organization: json['organization'],
      photo: json['photo'],
    );
  }
}