import 'package:articles_flutter/features/products/domain/entities/products.dart';

abstract class ProductsDataSource {
  Future<List<Products>> getProducts();
  Future<List<Products>> getFavorites();
  Future<Products> addFavorite(Products product);
  Future<Products> removeFavorite(Products product);
} 