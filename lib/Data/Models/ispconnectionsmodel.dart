/// Represents the details of an NTTN connection request.
///
/// This class encapsulates all necessary information regarding an NTTN connection request,
/// including the requester’s details, connection type, and status.
///
/// **Variables:**
/// - [name]: A String representing the name of the individual or entity requesting the connection.
/// - [organization]: A String representing the organization to which the requester belongs.
/// - [mobile]: A String representing the mobile phone number of the requester.
/// - [connectionType]: A String representing the type of connection requested (e.g., New, Upgrade).
/// - [applicationId]: A String representing the unique application ID associated with the connection request.
/// - [location]: A String representing the location where the connection is requested.
/// - [status]: A String representing the current status of the connection request.
/// - [link]: A String representing a link related to the connection request.
/// - [remark]: A String representing any additional remarks or comments related to the connection request.
class NTTNConnectionsDetails {
  /// The name of the individual or entity requesting the connection.
  final String name;

  /// The organization to which the requester belongs.
  final String organization;

  /// The mobile phone number of the requester.
  final String mobile;

  /// The type of connection requested (e.g., New, Upgrade).
  final String connectionType;

  /// The unique application ID associated with the connection request.
  final String applicationId;

  /// The location where the connection is requested.
  final String location;

  /// The current status of the connection request.
  final String status;

  /// A link related to the connection request (e.g., a reference or documentation link).
  final String link;

  /// Any additional remarks or comments related to the connection request.
  final String remark;

  /// Constructor for `NTTNConnectionsDetails`.
  ///
  /// - [name]: The name of the requester.
  /// - [organization]: The requester’s organization.
  /// - [mobile]: The mobile number of the requester.
  /// - [connectionType]: The type of connection requested.
  /// - [applicationId]: The unique ID of the application.
  /// - [location]: The location for the requested connection.
  /// - [status]: The status of the connection request.
  /// - [link]: A link associated with the request.
  /// - [remark]: Additional remarks about the request.
  NTTNConnectionsDetails({
    required this.name,
    required this.organization,
    required this.mobile,
    required this.connectionType,
    required this.applicationId,
    required this.location,
    required this.status,
    required this.link,
    required this.remark,
  });

  /// Factory constructor that creates an `NTTNConnectionsDetails` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data for the connection details.
  /// - Returns: An `NTTNConnectionsDetails` instance with fields populated from the JSON map.
  factory NTTNConnectionsDetails.fromJson(Map<String, dynamic> json) {
    return NTTNConnectionsDetails(
      name: json['name'],
      // Defaults to an empty string if null.
      organization: json['organization'],
      // Defaults to an empty string if null.
      mobile: json['mobile'],
      // Defaults to an empty string if null.
      connectionType: json['connection_type'],
      // Defaults to an empty string if null.
      applicationId: json['application_id'],
      // Defaults to an empty string if null.
      location: json['location'],
      // Defaults to an empty string if null.
      status: json['status'],
      // Defaults to an empty string if null.
      link: json['link'],
      // Defaults to an empty string if null.
      remark: json['remark'], // Defaults to an empty string if null.
    );
  }
}
