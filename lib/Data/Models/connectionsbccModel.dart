/// Represents a dashboard item for connection requests.
///
/// This class contains all necessary information about a connection request
/// to be displayed in the dashboard.
///
/// **Variables:**
/// - [name]: A String representing the name of the applicant or organization contact.
/// - [organization]: A String representing the name of the organization associated with the connection request.
/// - [mobile]: A String representing the mobile number of the applicant or contact person.
/// - [connectionType]: A String representing the type of connection requested (e.g., New, Upgrade).
/// - [provider]: A String representing the name of the provider handling the connection.
/// - [applicationID]: An integer representing the unique ID of the application.
/// - [status]: A String representing the current status of the application (e.g., Pending, Accepted, Rejected).
class DashboardItem {
  /// The name of the applicant or organization contact.
  final String name;

  /// The name of the organization associated with the connection request.
  final String organization;

  /// The mobile number of the applicant or contact person.
  final String mobile;

  /// The type of connection requested (e.g., New, Upgrade).
  final String connectionType;

  /// The name of the provider handling the connection.
  final String provider;

  /// The unique ID of the application.
  final int applicationID;

  /// The current status of the application (e.g., Pending, Accepted, Rejected).
  final String status;

  /// Constructor for `DashboardItem`.
  ///
  /// Initializes all fields, which are required for creating a dashboard item.
  DashboardItem({
    required this.name,
    required this.organization,
    required this.mobile,
    required this.connectionType,
    required this.provider,
    required this.applicationID,
    required this.status,
  });

  /// Factory constructor that creates a `DashboardItem` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `DashboardItem` instance populated with data from the JSON map.
  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      name: json['name'],
      // Extracts and assigns the name.
      organization: json['organization'],
      // Extracts and assigns the organization.
      mobile: json['mobile'],
      // Extracts and assigns the mobile number.
      connectionType: json['connectionType'],
      // Extracts and assigns the connection type.
      provider: json['provider'],
      // Extracts and assigns the provider name.
      applicationID: json['application_id'],
      // Extracts and assigns the application ID.
      status: json['status'], // Extracts and assigns the status.
    );
  }
}
