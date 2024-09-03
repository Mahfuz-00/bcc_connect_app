/// Represents a model for updating user profile information.
///
/// This class holds the necessary details required to update a user's profile.
///
/// **Variables:**
/// - [userId]: A String that represents the unique identifier of the user.
/// - [name]: A String that holds the user's name.
/// - [organization]: A String indicating the name of the user's organization.
/// - [designation]: A String specifying the user's job title or designation.
/// - [phone]: A String representing the user's phone number.
///
/// **Actions:**
/// - [toJson]: Converts the UserProfileUpdate object to a JSON map for API submission.
class UserProfileUpdateModel {
  /// Unique identifier for the user.
  final String userId;

  /// Full name of the user.
  final String name;

  /// Organization the user is associated with.
  final String organization;

  /// Job designation of the user.
  final String designation;

  /// Contact phone number of the user.
  final String phone;

  /// License number of the user.
  final String licenseNumber;

  /// Constructor for `UserProfileUpdate`.
  ///
  /// - [userId]: Unique identifier for the user.
  /// - [name]: Full name of the user.
  /// - [organization]: Organization the user is associated with.
  /// - [designation]: Job designation of the user.
  /// - [phone]: Contact phone number of the user.
  /// - [licenseNumber]: License number of the user.
  UserProfileUpdateModel({
    required this.userId,
    required this.name,
    required this.organization,
    required this.designation,
    required this.phone,
    required this.licenseNumber,
  });

  /// Converts the `UserProfileUpdate` instance to a JSON map.
  ///
  /// - Returns: A map containing the user's profile information.
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
