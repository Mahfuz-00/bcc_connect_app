/// The `UserProfileFull` class provides a comprehensive profile of a user,
/// including detailed attributes such as ID, name, organization, designation,
/// phone, license, ISP user type, email, and photo.
class UserProfileFull {
  /// Unique identifier for the user.
  final int id;

  /// Full name of the user.
  final String name;

  /// Organization to which the user belongs.
  final String organization;

  /// Job title or designation of the user within the organization.
  final String designation;

  /// Contact phone number of the user.
  final String phone;

  /// License number associated with the user.
  final String license;

  /// Type of ISP user (e.g., admin, isp).
  final String ISPuserType;

  /// Email address of the user.
  final String email;

  /// URL or path to the user's profile photo.
  final String photo;

  /// Constructor for `UserProfileFull`.
  ///
  /// - [id]: Unique identifier for the user.
  /// - [name]: Full name of the user.
  /// - [organization]: Organization to which the user belongs.
  /// - [designation]: Job title or designation of the user.
  /// - [phone]: Contact phone number of the user.
  /// - [license]: License number associated with the user.
  /// - [ISPuserType]: Type of ISP user.
  /// - [email]: Email address of the user.
  /// - [photo]: URL or path to the user's profile photo.
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

  /// Factory constructor that creates a `UserProfileFull` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data for the user profile.
  /// - Returns: A `UserProfileFull` instance with `id`, `name`, `organization`,
  ///   `designation`, `phone`, `license`, `ISPuserType`, `email`, and `photo`
  ///   populated from the JSON map.
  factory UserProfileFull.fromJson(Map<String, dynamic> json) {
    return UserProfileFull(
      id: json['userId'],
      // User's unique identifier from JSON.
      name: json['name'],
      // User's full name from JSON.
      organization: json['organization'],
      // User's organization from JSON.
      designation: json['designation'],
      // User's job title or designation from JSON.
      phone: json['phone'],
      // User's contact phone number from JSON.
      license: json['licenseNumber'],
      // User's license number from JSON.
      ISPuserType: json['ispUserType'],
      // Type of ISP user from JSON.
      email: json['email'],
      // User's email address from JSON.
      photo: json['photo'], // URL or path to user's profile photo from JSON.
    );
  }
}
