import 'package:articles_flutter/features/products/domain/datasource/product_datasource.dart';
import 'package:articles_flutter/features/products/domain/entities/products.dart';
import 'package:articles_flutter/features/products/domain/repositories/product_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDataSource dataSources;
  
  ProductsRepositoryImpl(this.dataSources);

  @override
  Future<List<Products>> getProducts() {
    return dataSources.getProducts();
  }

  @override
  Future<List<Products>> getFavorites() {
    return dataSources.getFavorites();
  }

  @override
  Future<Products> addFavorite(String id, ) {
    return dataSources.addFavorite(id);
  }

  @override
  Future<Products> removeFavorite(String id, ) {
    return dataSources.removeFavorite(id);
  }

}