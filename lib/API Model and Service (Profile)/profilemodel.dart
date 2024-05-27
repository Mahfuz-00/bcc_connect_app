class UserProfile {
  final int Id;
  final String name;
  final String organization;
  final String photo;

  UserProfile({
    required this.Id,
    required this.name,
    required this.organization,
    required this.photo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      Id: json['userId'],
      name: json['name'],
      organization: json['organization'],
      photo: json['photo'],
    );
  }
}