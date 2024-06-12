class ProfilePictureUpdateResponse {
  final bool status;
  final String message;

  ProfilePictureUpdateResponse({required this.status, required this.message});

  factory ProfilePictureUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePictureUpdateResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
