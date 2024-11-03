/// Represents a geographical division with its details.
///
/// This class encapsulates the unique identifier, names, and associated URL
/// of a division.
///
/// **Variables:**
/// - [id]: Unique identifier for the division.
/// - [name]: Name of the division in English.
/// - [bn_name]: Name of the division in Bengali.
/// - [url]: URL associated with the division.
class Division {
  /// Unique identifier for the division.
  final int id;

  /// Name of the division in English.
  final String name;

  /// Name of the division in Bengali.
  final String bn_name;

  /// URL associated with the division.
  final String url;

/*  final String created_at;
  final String updated_at;*/

  /// Constructor for `Division`.
  ///
  /// - [id]: Unique identifier for the division.
  /// - [name]: Name of the division in English.
  /// - [bn_name]: Name of the division in Bengali.
  /// - [url]: URL associated with the division.
  Division({
    required this.id,
    required this.name,
    required this.bn_name,
    required this.url,
    /*required this.created_at, required this.updated_at*/
  });

  /// Factory constructor to create a `Division` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the division.
  /// - Returns: A `Division` instance with `id`, `name`, `bn_name`, and `url`
  ///   populated from the JSON map.
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

/// Represents a district with its details.
///
/// This class encapsulates the unique identifier and name of a district.
///
/// **Variables:**
/// - [id]: Unique identifier for the district.
/// - [name]: Name of the district.
class District {
  /// Unique identifier for the district.
  final int id;

  /// Name of the district.
  final String name;

  /// Constructor for `District`.
  ///
  /// - [id]: Unique identifier for the district.
  /// - [name]: Name of the district.
  District({required this.id, required this.name});

  /// Factory constructor to create a `District` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the district.
  /// - Returns: A `District` instance with `id` and `name` populated from the JSON map.
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents an upazila with its details.
///
/// This class encapsulates the unique identifier and name of an upazila.
///
/// **Variables:**
/// - [id]: Unique identifier for the upazila.
/// - [name]: Name of the upazila.
class Upazila {
  /// Unique identifier for the upazila.
  final int id;

  /// Name of the upazila.
  final String name;

  /// Constructor for `Upazila`.
  ///
  /// - [id]: Unique identifier for the upazila.
  /// - [name]: Name of the upazila.
  Upazila({required this.id, required this.name});

  /// Factory constructor to create an `Upazila` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the upazila.
  /// - Returns: An `Upazila` instance with `id` and `name` populated from the JSON map.
  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents a union with its details.
///
/// This class encapsulates the unique identifier and name of a union.
///
/// **Variables:**
/// - [id]: Unique identifier for the union.
/// - [name]: Name of the union.
class Union {
  /// Unique identifier for the union.
  final int id;

  /// Name of the union.
  final String name;

  /// Constructor for `Union`.
  ///
  /// - [id]: Unique identifier for the union.
  /// - [name]: Name of the union.
  Union({required this.id, required this.name});

  /// Factory constructor to create a `Union` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the union.
  /// - Returns: A `Union` instance with `id` and `name` populated from the JSON map.
  factory Union.fromJson(Map<String, dynamic> json) {
    return Union(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents an NTTN provider with its details.
///
/// This class encapsulates the unique identifier and name of an NTTN provider.
///
/// **Variables:**
/// - [id]: Unique identifier for the NTTN provider.
/// - [provider]: Name of the NTTN provider.
class NTTNProvider {
  /// Unique identifier for the NTTN provider.
  final int id;

  /// Name of the NTTN provider.
  final String provider;

  /// Constructor for `NTTNProvider`.
  ///
  /// - [id]: Unique identifier for the NTTN provider.
  /// - [provider]: Name of the NTTN provider.
  NTTNProvider({required this.id, required this.provider});

  /// Factory constructor to create an `NTTNProvider` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the NTTN provider.
  /// - Returns: An `NTTNProvider` instance with `id` and `provider` populated from the JSON map.
  factory NTTNProvider.fromJson(Map<String, dynamic> json) {
    return NTTNProvider(
      id: json['id'],
      provider: json['provider'],
    );
  }
}
