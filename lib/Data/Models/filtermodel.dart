/// The `Division` class represents a geographic division entity,
/// primarily used for identifying and handling divisions within the application.
class Division {
  /// The unique identifier for the division.
  final int? id;

  /// Constructor for `Division`.
  ///
  /// - [id]: The division's unique identifier, which is optional.
  Division({this.id});

  /// Factory constructor that creates a `Division` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `Division` instance populated with the `id` from the JSON map.
  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json[
          'division_id'], // Maps 'division_id' from JSON to the `id` field.
    );
  }
}

/// The `District` class represents a district entity,
/// primarily used for identifying and handling districts within the application.
class District {
  /// The unique identifier for the district.
  final int? id;

  /// Constructor for `District`.
  ///
  /// - [id]: The district's unique identifier, which is optional.
  District({this.id});

  /// Factory constructor that creates a `District` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `District` instance populated with the `id` from the JSON map.
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json[
          'district_id'], // Maps 'district_id' from JSON to the `id` field.
    );
  }
}

/// The `Upazila` class represents an upazila entity,
/// primarily used for identifying and handling upazilas within the application.
class Upazila {
  /// The unique identifier for the upazila.
  final int? id;

  /// Constructor for `Upazila`.
  ///
  /// - [id]: The upazila's unique identifier, which is optional.
  Upazila({this.id});

  /// Factory constructor that creates an `Upazila` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: An `Upazila` instance populated with the `id` from the JSON map.
  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['upazila_id'], // Maps 'upazila_id' from JSON to the `id` field.
    );
  }
}

/// The `Union` class represents a union entity,
/// primarily used for identifying and handling unions within the application.
class Union {
  /// The unique identifier for the union.
  final int? id;

  /// Constructor for `Union`.
  ///
  /// - [id]: The union's unique identifier, which is optional.
  Union({this.id});

  /// Factory constructor that creates a `Union` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data.
  /// - Returns: A `Union` instance populated with the `id` from the JSON map.
  factory Union.fromJson(Map<String, dynamic> json) {
    return Union(
      id: json['union_id'], // Maps 'union_id' from JSON to the `id` field.
    );
  }
}
