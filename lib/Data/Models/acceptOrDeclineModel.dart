class ConnectionStatus {
  final String type;
  final int ispConnectionId;

  ConnectionStatus({
    required this.type,
    required this.ispConnectionId,
  });

  factory ConnectionStatus.fromJson(Map<String, dynamic> json) {
    return ConnectionStatus(
      type: json['type'],
      ispConnectionId: json['isp_connection_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'isp_connection_id': ispConnectionId,
    };
  }
}
