import 'package:articles_flutter/features/products/domain/entities/products.dart';

class ProductsMapper {
  static Products productsJsonToEntity(Map<String, dynamic> json) {
    return Products(
      id: json['ID'].toString(),
      vendor: json['Vendor'],
      productName: json['ProductName'],
      rating: json['Rating'],
      imgUrl: json['ImageURL'],
    );
  }
}
