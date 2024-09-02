/// Represents a connection request item.
///
/// This class contains all necessary information about a connection request
/// including applicant details and connection status.
///
/// **Variables:**
/// - [name]: A String representing the name of the applicant or organization contact.
/// - [organization]: A String representing the name of the organization associated with the connection.
/// - [mobile]: A String representing the mobile number of the applicant or contact person.
/// - [connectionType]: A String representing the type of connection requested (e.g., New, Upgrade).
/// - [provider]: A String representing the name of the provider handling the connection.
/// - [status]: A String representing the current status of the connection (e.g., Pending, Accepted, Rejected).
class Connections {
  /// The name of the applicant or organization contact.
  final String name;

  /// The name of the organization associated with the connection.
  final String organization;

  /// The mobile number of the applicant or contact person.
  final String mobile;

  /// The type of connection requested (e.g., New, Upgrade).
  final String connectionType;

  /// The name of the provider handling the connection.
  final String provider;

  /// The current status of the connection (e.g., Pending, Accepted, Rejected).
  final String status;

  /// Constructor for `Connections`.
  ///
  /// Initializes all fields, which are required for creating a connection item.
  Connections({
    required this.name,
    required this.organization,
    required this.mobile,
    required this.connectionType,
    required this.provider,
    required this.status,
  });

  /// Factory constructor that creates a `Connections` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `Connections` instance populated with data from the JSON map.
  factory Connections.fromJson(Map<String, dynamic> json) {
    return Connections(
      name: json['name'] ?? '',
      // Defaults to an empty string if the value is null.
      organization: json['organization'] ?? '',
      // Defaults to an empty string if the value is null.
      mobile: json['mobile'] ?? '',
      // Defaults to an empty string if the value is null.
      connectionType: json['connection_type'] ?? '',
      // Defaults to an empty string if the value is null.
      provider: json['provider'] ?? '',
      // Defaults to an empty string if the value is null.
      status: json['status'] ??
          '', // Defaults to an empty string if the value is null.
    );
  }
}
