import '../../../core/constants/api_query.dart';

/// One page of a paginated list plus the server's paging meta.
class Paged<T> {
  const Paged({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
  });

  factory Paged.fromEnvelope(List<T> items, Map<String, dynamic> meta) =>
      Paged<T>(
        items: items,
        page: (meta[ApiMeta.page] as num?)?.toInt() ?? 1,
        lastPage: (meta[ApiMeta.lastPage] as num?)?.toInt() ?? 1,
        total: (meta[ApiMeta.total] as num?)?.toInt() ?? items.length,
      );

  final List<T> items;
  final int page;
  final int lastPage;
  final int total;

  bool get hasMore => page < lastPage;
}
