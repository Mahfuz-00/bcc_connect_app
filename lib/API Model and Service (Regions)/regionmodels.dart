class Division {
  final String id;
  final String name;
  final String bn_name;
  final String url;
/*  final String created_at;
  final String updated_at;*/

  Division({required this.id, required this.name, required this.bn_name, required this.url, /*required this.created_at, required this.updated_at*/});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bn_name: json['bn_name'] ?? '',
      url: json['url'] ?? '',
/*      created_at: json['created_at'],
      updated_at: json['updated_at'],*/
    );
  }
}

class District {
  final String id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Upazila {
  final String id;
  final String name;

  Upazila({required this.id, required this.name});

  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Union {
  final String id;
  final String name;

  Union({required this.id, required this.name});

  factory Union.fromJson(Map<String, dynamic> json) {
    return Union(
      id: json['id'],
      name: json['name'],
    );
  }
}

class NTTNProvider {
  final int id;
  final String provider;

  NTTNProvider({required this.id, required this.provider});

  factory NTTNProvider.fromJson(Map<String, dynamic> json) {
    return NTTNProvider(
      id: json['id'],
      provider: json['provider'],
    );
  }
}
