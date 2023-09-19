import 'package:articles_flutter/config/const/environment.dart';
import 'package:articles_flutter/features/products/domain/datasource/product_datasource.dart';
import 'package:articles_flutter/features/products/domain/entities/products.dart';
import 'package:articles_flutter/features/products/infrastructure/helpers/database_helper.dart';
import 'package:articles_flutter/features/products/infrastructure/mappers/product_mapper.dart';
import 'package:dio/dio.dart';

class ProductDataSourceImpl implements ProductsDataSource {
  final Dio dio;
  final String accessToken;
  final DatabaseHelper databaseHelper;

   /*
    Auth-Service tiene middleware que valida el token
    El token viene del provider
  */
  ProductDataSourceImpl({
    required this.accessToken,
    required this.databaseHelper,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Enviroment.apiURL,
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );

  @override
  Future<List<Products>> getProducts() async {
    try {
      final response = await dio.get('/products');
      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
      final jsonData = response.data as List<dynamic>;
      final products = jsonData
          .map((data) => ProductsMapper.productsJsonToEntity(data))
          .toList();
      return products;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<List<Products>> getFavorites() async {
    try {
      final database = await databaseHelper.database;
      final favoriteProducts = await database.query('favorites');
      final products = favoriteProducts
          .map((data) => ProductsMapper.productsJsonToEntity(data))
          .toList();
      return products;
    } catch (e) {
      _handleError(e);
      throw Exception('Error obteniendo favoritos');
    }
  }

  @override
  Future<Products> addFavorite(Products product) async {
    try {
      final response = await dio.post('/favorites/${product.id}');
      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
      final database = await databaseHelper.database;
      await database.insert(
        'favorites',
        {
          'id': product.id,
          'vendor': product.vendor,
          'productName': product.productName,
          'rating': product.rating,
          'imageUrl': product.imageUrl,
        },
      );
      final updatedProduct = product.copyWith(isFavorite: true);
      return updatedProduct;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<Products> removeFavorite(Products product) async {
    try {
      final response = await dio.delete('/favorites/${product.id}');
      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
      final database = await databaseHelper.database;
      await database
          .delete('favorites', where: 'id = ?', whereArgs: [product.id]);
      final updatedProduct = product.copyWith(isFavorite: false);
      return updatedProduct;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(dynamic e) {
    print('Error: $e');
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        print('Response data: ${response.data}');
      }
    }
  }
}