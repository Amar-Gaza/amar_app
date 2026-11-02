/// One option of a segmented control.
class SegmentItem<T> {
  const SegmentItem({required this.value, required this.label, this.count});

  final T value;
  final String label;
  final int? count;
}
