/// Body of POST /orders/{order}/rate.
class RateOrderRequest {
  const RateOrderRequest({
    required this.stars,
    this.comment,
    this.vendorStars,
    this.vendorComment,
  });

  final int stars;
  final String? comment;
  final int? vendorStars;
  final String? vendorComment;

  Map<String, dynamic> toJson() => {
        'stars': stars,
        if (comment != null) 'comment': comment,
        if (vendorStars != null) 'vendor_stars': vendorStars,
        if (vendorComment != null) 'vendor_comment': vendorComment,
      };
}
