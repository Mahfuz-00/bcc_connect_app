/// The `ConnectionStatus` class represents the status of a connection in the BCC Connect Network App.
///
/// It holds details about the type of connection and the corresponding ISP connection ID.
class ConnectionStatus {
  /// The type of connection (e.g., "New", "Update").
  final String type;

  /// The unique identifier for the ISP connection.
  final int ispConnectionId;

  /// Constructor for `ConnectionStatus`.
  ///
  /// Requires [type] and [ispConnectionId] to be provided.
  ConnectionStatus({
    required this.type,
    required this.ispConnectionId,
  });

  /// Factory constructor that creates a `ConnectionStatus` instance from a JSON map.
  ///
  /// - [json] is a `Map<String, dynamic>` containing the data from which to create the instance.
  /// - Returns a `ConnectionStatus` object.
  factory ConnectionStatus.fromJson(Map<String, dynamic> json) {
    return ConnectionStatus(
      type: json['type'], // Extracts the connection type from the JSON.
      ispConnectionId: json[
          'isp_connection_id'], // Extracts the ISP connection ID from the JSON.
    );
  }

  /// Converts the `ConnectionStatus` instance into a JSON map.
  ///
  /// - Returns a `Map<String, dynamic>` representation of the instance.
  Map<String, dynamic> toJson() {
    return {
      'type': type, // The connection type.
      'isp_connection_id': ispConnectionId, // The ISP connection ID.
    };
  }
}
