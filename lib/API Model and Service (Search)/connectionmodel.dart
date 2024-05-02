class Connections {
  final String name;
  final String organization;
  final String mobile;
  final String connectionType;
  final String provider;
  final String status;

  Connections({
    required this.name,
    required this.organization,
    required this.mobile,
    required this.connectionType,
    required this.provider,
    required this.status,
  });

  factory Connections.fromJson(Map<String, dynamic> json) {
    return Connections(
      name: json['name'] ?? '',
      organization: json['organization'] ?? '',
      mobile: json['mobile'] ?? '',
      connectionType: json['connection_type'] ?? '',
      provider: json['provider'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
