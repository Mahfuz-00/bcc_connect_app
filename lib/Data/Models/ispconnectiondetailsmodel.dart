/// The `ISPConnectionDetails` class represents the details of an ISP connection
/// request, including its type, provider, and status.
class ISPConnectionDetails {
  /// The type of connection (e.g., New, Update).
  final String connectionType;

  /// The name of the provider handling the connection.
  final String provider;

  /// The unique application ID associated with the connection request.
  final String applicationId;

  /// The phone number associated with the connection request.
  final String phone;

  /// The location where the connection is requested.
  final String location;

  /// The time when the connection request was created.
  final String time;

  /// The current status of the connection request.
  final String status;

  /// Constructor for `ISPConnectionDetails`.
  ///
  /// - [connectionType]: The type of ISP connection.
  /// - [provider]: The ISP provider name.
  /// - [applicationId]: The unique application ID.
  /// - [phone]: The phone number associated with the request.
  /// - [location]: The requested connection location.
  /// - [time]: The timestamp when the request was created.
  /// - [status]: The current status of the request.
  ISPConnectionDetails({
    required this.connectionType,
    required this.provider,
    required this.applicationId,
    required this.phone,
    required this.location,
    required this.time,
    required this.status,
  });

  /// Factory constructor that creates an `ISPConnectionDetails` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: An `ISPConnectionDetails` instance populated with the details from the JSON map.
  factory ISPConnectionDetails.fromJson(Map<String, dynamic> json) {
    return ISPConnectionDetails(
      connectionType: json['connection_type'] ?? '',
      // Defaults to an empty string if null.
      provider: json['provider'] ?? '',
      // Defaults to an empty string if null.
      applicationId: json['application_id'] ?? '',
      // Defaults to an empty string if null.
      phone: json['phone'] ?? '',
      // Defaults to an empty string if null.
      location: json['location'] ?? '',
      // Defaults to an empty string if null.
      time: json['created_at'] ?? '',
      // Defaults to an empty string if null.
      status: json['status'] ?? '', // Defaults to an empty string if null.
    );
  }
}
