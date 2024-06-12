class DashboardItem {
  final String name;
  final String organization;
  final String mobile;
  final String connectionType;
  final String provider;
  final int applicationID;
  final String status;

  DashboardItem({
    required this.name,
    required this.organization,
    required this.mobile,
    required this.connectionType,
    required this.provider,
    required this.applicationID,
    required this.status,
  });

  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      name: json['name'],
      organization: json['organization'],
      mobile: json['mobile'],
      connectionType: json['connectionType'],
      provider: json['provider'],
      applicationID: json['application_id'],
      status: json['status'],
    );
  }
}