
class PosterSize {
  final String title;
  final String size;

  const PosterSize({required this.title, required this.size});

  factory PosterSize.fromMap(Map<String, String> map) {
    return PosterSize(
      title: map['title'] ?? '',
      size: map['size'] ?? '',
    );
  }

  // Parse size string into width and height dimensions
  List<double> getDimensions() {
    final parts = size.split('*');
    if (parts.length == 2) {
      return [
        double.tryParse(parts[0]) ?? 0,
        double.tryParse(parts[1]) ?? 0,
      ];
    }
    return [0, 0];
  }
}