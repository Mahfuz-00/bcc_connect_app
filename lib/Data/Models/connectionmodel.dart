class ConnectionRequestModel {
  final String divisionId;
  final String districtId;
  final String upazilaId;
  final String unionId;
  final int nttnProvider;
/*  final String requestType;*/
  final String linkCapacity;
  final String remark;

  ConnectionRequestModel({
    required this.divisionId,
    required this.districtId,
    required this.upazilaId,
    required this.unionId,
    required this.nttnProvider,
/*    required this.requestType,*/
    required this.linkCapacity,
    required this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'division': divisionId,
      'district': districtId,
      'upazila': upazilaId,
      'union': unionId,
      'nttn_provider': nttnProvider,
/*      'request_type': requestType,*/
      'link_capacity': linkCapacity,
      'remark': remark,
    };
  }
}
