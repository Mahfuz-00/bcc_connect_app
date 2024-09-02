/// Represents a division in the search results.
///
/// This class encapsulates the unique identifier, names, and associated URL
/// of a division.
///
/// **Variables:**
/// - [id]: Unique identifier for the division.
/// - [name]: Name of the division.
/// - [bn_name]: Name of the division in Bengali.
/// - [url]: URL associated with the division.
class DivisionSearch {
  /// Unique identifier for the division.
  final String id;

  /// Name of the division.
  final String name;

  /// Name of the division in Bengali.
  final String bn_name;

  /// URL associated with the division.
  final String url;

  /// Constructor for `DivisionSearch`.
  ///
  /// - [id]: Unique identifier for the division.
  /// - [name]: Name of the division.
  /// - [bn_name]: Name of the division in Bengali.
  /// - [url]: URL associated with the division.
  DivisionSearch({
    required this.id,
    required this.name,
    required this.bn_name,
    required this.url,
    /*required this.created_at, required this.updated_at*/
  });

  /// Factory constructor to create a `DivisionSearch` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the division search result.
  /// - Returns: A `DivisionSearch` instance with properties populated from the JSON map.
  factory DivisionSearch.fromJson(Map<String, dynamic> json) {
    return DivisionSearch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bn_name: json['bn_name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

/// Represents a district in the search results.
///
/// This class encapsulates the unique identifier and name of a district.
///
/// **Variables:**
/// - [id]: Unique identifier for the district.
/// - [name]: Name of the district.
class DistrictSearch {
  /// Unique identifier for the district.
  final String id;

  /// Name of the district.
  final String name;

  /// Constructor for `DistrictSearch`.
  ///
  /// - [id]: Unique identifier for the district.
  /// - [name]: Name of the district.
  DistrictSearch({required this.id, required this.name});

  /// Factory constructor to create a `DistrictSearch` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the district search result.
  /// - Returns: A `DistrictSearch` instance with properties populated from the JSON map.
  factory DistrictSearch.fromJson(Map<String, dynamic> json) {
    return DistrictSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents an upazila in the search results.
///
/// This class encapsulates the unique identifier and name of an upazila.
///
/// **Variables:**
/// - [id]: Unique identifier for the upazila.
/// - [name]: Name of the upazila.
class UpazilaSearch {
  /// Unique identifier for the upazila.
  final String id;

  /// Name of the upazila.
  final String name;

  /// Constructor for `UpazilaSearch`.
  ///
  /// - [id]: Unique identifier for the upazila.
  /// - [name]: Name of the upazila.
  UpazilaSearch({required this.id, required this.name});

  /// Factory constructor to create an `UpazilaSearch` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the upazila search result.
  /// - Returns: An `UpazilaSearch` instance with properties populated from the JSON map.
  factory UpazilaSearch.fromJson(Map<String, dynamic> json) {
    return UpazilaSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents a union in the search results.
///
/// This class encapsulates the unique identifier and name of a union.
///
/// **Variables:**
/// - [id]: Unique identifier for the union.
/// - [name]: Name of the union.
class UnionSearch {
  /// Unique identifier for the union.
  final String id;

  /// Name of the union.
  final String name;

  /// Constructor for `UnionSearch`.
  ///
  /// - [id]: Unique identifier for the union.
  /// - [name]: Name of the union.
  UnionSearch({required this.id, required this.name});

  /// Factory constructor to create a `UnionSearch` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the union search result.
  /// - Returns: A `UnionSearch` instance with properties populated from the JSON map.
  factory UnionSearch.fromJson(Map<String, dynamic> json) {
    return UnionSearch(
      id: json['id'],
      name: json['name'],
    );
  }
}

/// Represents the result of an NTTN provider search.
///
/// This class encapsulates the unique identifier, name, and phone number
/// of an NTTN provider.
///
/// **Variables:**
/// - [id]: Unique identifier for the NTTN provider.
/// - [name]: Name of the NTTN provider.
/// - [phonenumber]: Phone number of the NTTN provider.
class NTTNProviderResult {
  /// Unique identifier for the NTTN provider.
  final String id;

  /// Name of the NTTN provider.
  final String name;

  /// Phone number of the NTTN provider.
  final String phonenumber;

  /// Constructor for `NTTNProviderResult`.
  ///
  /// - [id]: Unique identifier for the NTTN provider.
  /// - [name]: Name of the NTTN provider.
  /// - [phonenumber]: Phone number of the NTTN provider.
  NTTNProviderResult(
      {required this.id, required this.name, required this.phonenumber});

  /// Factory constructor to create an `NTTNProviderResult` instance from a JSON map.
  ///
  /// - [json]: A map containing JSON data for the NTTN provider result.
  /// - Returns: An `NTTNProviderResult` instance with properties populated from the JSON map.
  factory NTTNProviderResult.fromJson(Map<String, dynamic> json) {
    return NTTNProviderResult(
      id: json['id'],
      name: json['nttn'],
      phonenumber: json['phone'],
    );
  }
}
