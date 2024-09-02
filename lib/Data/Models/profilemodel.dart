/// Represents a user profile containing essential user information.
///
/// This class encapsulates user-related data and provides a method for
/// creating an instance from JSON data.
///
/// **Variables:**
/// - [Id]: An int that holds the unique identifier for the user.
/// - [name]: A String that contains the name of the user.
/// - [organization]: A String that specifies the organization the user belongs to.
/// - [photo]: A String that holds the URL or path to the user's profile photo.
/// - [user]: A String that indicates the type of user (e.g., admin, guest).
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
