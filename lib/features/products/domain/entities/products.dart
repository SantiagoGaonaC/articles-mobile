class Products {
  final int id;
  final String vendor;
  final String productName;
  final double rating;
  final String imageUrl;
  final bool isFavorite;

  Products({
    required this.id,
    required this.vendor,
    required this.productName,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Products copyWith({
    int? id,
    String? vendor,
    String? productName,
    double? rating,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Products(
      id: id ?? this.id,
      vendor: vendor ?? this.vendor,
      productName: productName ?? this.productName,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
