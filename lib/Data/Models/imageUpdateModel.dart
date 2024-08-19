/// The `ProfilePictureUpdateResponse` class represents the response received
/// after attempting to update a user's profile picture.
class ProfilePictureUpdateResponse {
  /// A boolean indicating whether the profile picture update was successful.
  final bool status;

  /// A message providing additional details about the update attempt,
  /// such as success or failure reasons.
  final String message;

  /// Constructor for `ProfilePictureUpdateResponse`.
  ///
  /// - [status]: The status of the profile picture update (true if successful, false otherwise).
  /// - [message]: A message detailing the outcome of the update attempt.
  ProfilePictureUpdateResponse({required this.status, required this.message});

  /// Factory constructor that creates a `ProfilePictureUpdateResponse` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `ProfilePictureUpdateResponse` instance populated with the `status`
  ///   and `message` from the JSON map.
  factory ProfilePictureUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUpdateResponse(
      status: json['status'], // Maps 'status' from JSON to the `status` field.
      message:
          json['message'], // Maps 'message' from JSON to the `message` field.
    );
  }
}
