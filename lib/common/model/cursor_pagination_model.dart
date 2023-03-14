import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});
  CursorPaginationMeta copyWith({int? count, bool? hasMore}) {
    return CursorPaginationMeta(count: count ?? this.count, hasMore: hasMore ?? this.hasMore);
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorPaginationMetaFromJson(json);
}

/// 여러가지 상태를 나타내기 위해 부모 클래스를 하나 선언
abstract class CursorPaginationBase<T> {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(meta: meta ?? this.meta, data: data ?? this.data);
  }

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

class CursorPaginationError<T> extends CursorPaginationBase<T> {
  final String message;

  CursorPaginationError({required this.message});
}

// Loading 중인 상태
class CursorPaginationLoading<T> extends CursorPaginationBase<T> {}

// 새로 고침
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 추가 요청
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
