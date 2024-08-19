/// The `UserProfile` class represents the profile information of a user.
/// It contains details such as user ID, name, organization, and photo URL.
class UserProfile {
  /// Unique identifier for the user.
  final int Id;

  /// Name of the user.
  final String name;

  /// Organization to which the user belongs.
  final String organization;

  /// URL or path to the user's profile photo.
  final String photo;

  /// Constructor for `UserProfile`.
  ///
  /// - [Id]: Unique identifier for the user.
  /// - [name]: Name of the user.
  /// - [organization]: Organization to which the user belongs.
  /// - [photo]: URL or path to the user's profile photo.
  UserProfile({
    required this.Id,
    required this.name,
    required this.organization,
    required this.photo,
  });

  /// Factory constructor that creates a `UserProfile` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data for the user profile.
  /// - Returns: A `UserProfile` instance with `Id`, `name`, `organization`, and `photo` populated from the JSON map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      Id: json['userId'], // User's unique identifier from JSON.
      name: json['name'], // User's name from JSON.
      organization: json['organization'], // User's organization from JSON.
      photo: json['photo'], // URL or path to user's photo from JSON.
    );
  }
}
