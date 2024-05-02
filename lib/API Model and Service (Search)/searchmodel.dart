class DivisionSearch {
  final String id;
  final String name;
  final String bn_name;
  final String url;

  DivisionSearch({required this.id, required this.name, required this.bn_name, required this.url, /*required this.created_at, required this.updated_at*/});

  factory DivisionSearch.fromJson(Map<String, dynamic> json) {
    return DivisionSearch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bn_name: json['bn_name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class DistrictSearch {
  final String id;
  final String name;

  DistrictSearch({required this.id, required this.name});

  factory DistrictSearch.fromJson(Map<String, dynamic> json) {
    return DistrictSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UpazilaSearch {
  final String id;
  final String name;

  UpazilaSearch({required this.id, required this.name});

  factory UpazilaSearch.fromJson(Map<String, dynamic> json) {
    return UpazilaSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UnionSearch {
  final String id;
  final String name;

  UnionSearch({required this.id, required this.name});

  factory UnionSearch.fromJson(Map<String, dynamic> json) {
    return UnionSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

class NTTNProviderResult {
  final String id;
  final String name;
  final String phonenumber;

  NTTNProviderResult({required this.id, required this.name, required this.phonenumber});

  factory NTTNProviderResult.fromJson(Map<String, dynamic> json) {
    return NTTNProviderResult(
      id: json['id'],
      name: json['nttn'],
      phonenumber: json['phone'],
    );
  }
}
