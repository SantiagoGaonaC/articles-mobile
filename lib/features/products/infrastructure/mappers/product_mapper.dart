import 'package:articles_flutter/features/products/domain/entities/products.dart';

class ProductsMapper {
  static Products productsJsonToEntity(Map<String, dynamic> json) {
    return Products(
      id: json['id'].toString(),
      vendor: json['vendor'],
      productName: json['productName'],
      rating: json['rating'],
      imageUrl: json['imageUrl'],
    );
  }
}
