class ISPConnectionDetails {
  final String connectionType;
  final String provider;
  final String applicationId;
  final String phone;
  final String location;
  final String time;
  final String status;

  ISPConnectionDetails({
    required this.connectionType,
    required this.provider,
    required this.applicationId,
    required this.phone,
    required this.location,
    required this.time,
    required this.status,
  });

  factory ISPConnectionDetails.fromJson(Map<String, dynamic> json) {
    return ISPConnectionDetails(
      connectionType: json['connection_type'] ?? '',
      provider: json['provider'] ?? '',
      applicationId: json['application_id'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      time: json['created_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
