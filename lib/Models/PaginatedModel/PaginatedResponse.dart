class PaginatedResponse<T> {
  final List<T> items;
  final String? nextCursor;

  PaginatedResponse({
    required this.items,
    this.nextCursor,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List).map(fromJsonT).toList(),
      nextCursor: json['next_cursor'],
    );
  }
}
