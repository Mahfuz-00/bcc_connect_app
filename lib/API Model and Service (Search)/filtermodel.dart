class Division {
  final int? id;

  Division({this.id});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['division_id'],
    );
  }
}

class District {
  final int? id;

  District({this.id});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['district_id'],
    );
  }
}

class Upazila {
  final int? id;

  Upazila({this.id});

  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['upazila_id'],
    );
  }
}

class Union {
  final int? id;

  Union({this.id});

  factory Union.fromJson(Map<String, dynamic> json) {
    return Union(
      id: json['union_id'],
    );
  }
}
