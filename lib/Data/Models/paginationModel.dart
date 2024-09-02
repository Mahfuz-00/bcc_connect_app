/// Represents the pagination information for a data response.
///
/// This class encapsulates details about the current pagination state,
/// including the URLs for the next and previous pages of data.
///
/// **Variables:**
/// - [nextPage]: A String? that holds the URL for the next page of results, if available.
/// - [previousPage]: A String? that holds the URL for the previous page of results, if available.
///
/// **Actions:**
/// - [canFetchNext]: A boolean getter that determines if there is a next page to fetch.
/// - [canFetchPrevious]: A boolean getter that determines if there is a previous page to fetch.
class Pagination {
  /// The URL or identifier for the next page of results.
  final String? nextPage;

  /// The URL or identifier for the previous page of results.
  final String? previousPage;

  /// Constructor for `Pagination`.
  ///
  /// - [nextPage]: The URL or identifier for the next page. Can be `null`.
  /// - [previousPage]: The URL or identifier for the previous page. Can be `null`.
  Pagination({required this.nextPage, required this.previousPage});

  /// Checks if there is a next page available for fetching.
  ///
  /// - Returns: `true` if `nextPage` is not `null` and not "None"; otherwise `false`.
  bool get canFetchNext => nextPage != null && nextPage != "None";

  /// Checks if there is a previous page available for fetching.
  ///
  /// - Returns: `true` if `previousPage` is not `null` and not "None"; otherwise `false`.
  bool get canFetchPrevious => previousPage != null && previousPage != "None";

  /// Factory constructor that creates a `Pagination` instance from a JSON map.
  ///
  /// - [json]: A map containing the JSON data for pagination.
  /// - Returns: A `Pagination` instance with `nextPage` and `previousPage` populated from the JSON map.
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      nextPage: json['next_page'] as String?,
      // Nullable String for next page URL.
      previousPage: json['previous_page']
          as String?, // Nullable String for previous page URL.
    );
  }
}
