class Pagination {
  final String? nextPage;
  final String? previousPage;

  Pagination({required this.nextPage, required this.previousPage});

  bool get canFetchNext => nextPage != null && nextPage != "None";
  bool get canFetchPrevious => previousPage != null && previousPage != "None";

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      nextPage: json['next_page'] as String?,
      previousPage: json['previous_page'] as String?,
    );
  }
}
