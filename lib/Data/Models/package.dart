class Package {
  final int? id;
  final String? name;
  final String? unit;
  final String? packageName;
  final String? packageDescription;
  final double? charge;
  final int? createdBy;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Package({
    this.id,
    this.name,
    this.unit,
    this.packageName,
    this.packageDescription,
    this.charge,
    this.createdBy,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Package object from JSON
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] as int?,
      name: json['name'] as String?,
      unit: json['unit'] as String?,
      packageName: json['package_name'] as String?,
      packageDescription: json['package_description'] as String?,
      charge: (json['charge'] as num?)?.toDouble(),
      createdBy: json['created_by'] as int?,
      status: json['status'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  // Method to convert a Package object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'package_name': packageName,
      'package_description': packageDescription,
      'charge': charge,
      'created_by': createdBy,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
