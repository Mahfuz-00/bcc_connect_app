/// Represents a connection request model.
///
/// This class contains all necessary information to create a connection request.
///
/// **Variables:**
/// - [divisionId]: A String representing the ID of the division where the connection is requested.
/// - [districtId]: A String representing the ID of the district where the connection is requested.
/// - [upazilaId]: A String representing the ID of the upazila (sub-district) where the connection is requested.
/// - [unionId]: A String representing the ID of the union where the connection is requested.
/// - [nttnProvider]: An integer representing the ID of the NTTN provider selected for the connection.
/// - [linkCapacity]: A String representing the capacity of the link being requested.
/// - [remark]: A String containing any additional remarks or comments about the connection request.
class ConnectionRequestModel {
  /// The ID of the division where the connection is requested.
  final String divisionId;

  /// The ID of the district where the connection is requested.
  final String districtId;

  /// The ID of the upazila (sub-district) where the connection is requested.
  final String upazilaId;

  /// The ID of the union where the connection is requested.
  final String unionId;

  /// The ID of the NTTN provider selected for the connection.
  final int nttnProvider;

/*  final String requestType;*/

  /// The capacity of the link being requested.
  final String linkCapacity;

  /// Any additional remarks or comments about the connection request.
  final String remark;

  /// Constructor for `ConnectionRequestModel`.
  ///
  /// All fields are required and must be provided when creating an instance of this class.
  ConnectionRequestModel({
    required this.divisionId,
    required this.districtId,
    required this.upazilaId,
    required this.unionId,
    required this.nttnProvider,
    required this.linkCapacity,
    required this.remark,
  });

  /// Converts the `ConnectionRequestModel` instance into a JSON map.
  ///
  /// - Returns a `Map<String, dynamic>` containing all the details of the connection request.
  Map<String, dynamic> toJson() {
    return {
      'division': divisionId,
      'district': districtId,
      'upazila': upazilaId,
      'union': unionId,
      'nttn_provider': nttnProvider,
      'link_capacity': linkCapacity,
      'remark': remark,
    };
  }
}
