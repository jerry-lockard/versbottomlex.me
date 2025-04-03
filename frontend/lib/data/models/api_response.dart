class ApiResponse<T> {
  final String status;
  final String? message;
  final T? data;
  final List<ApiError>? errors;

  ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] != null
          ? (json['errors'] as List)
              .map((e) => ApiError.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}

class ApiError {
  final String field;
  final String message;

  ApiError({
    required this.field,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      field: json['field'] as String,
      message: json['message'] as String,
    );
  }
}

// Generic pagination response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int count;
  final int limit;
  final int offset;

  PaginatedResponse({
    required this.items,
    required this.count,
    required this.limit,
    required this.offset,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    final itemsJson = json['items'] ?? json['streams'] ?? json['payments'] ?? json['messages'] ?? [];
    
    return PaginatedResponse<T>(
      items: (itemsJson as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
    );
  }

  bool get hasMore => offset + items.length < count;
  int get nextOffset => offset + limit;
}