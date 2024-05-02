class NTTNConnectionsDetails {
  final String name;
  final String organization;
  final String mobile;
  final String connectionType;
  final String applicationId;
  final String location;
  final String status;
  final String link;
  final String remark;

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

  factory NTTNConnectionsDetails.fromJson(Map<String, dynamic> json) {
    return NTTNConnectionsDetails(
      name: json['name'],
      organization: json['organization'],
      mobile: json['mobile'],
      connectionType: json['connection_type'],
      applicationId: json['application_id'],
      location: json['location'],
      status: json['status'],
      link: json['link'],
      remark: json['remark'],
    );
  }
}
