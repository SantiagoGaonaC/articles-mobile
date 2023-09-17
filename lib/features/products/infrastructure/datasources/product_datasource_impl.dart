import 'package:articles_flutter/config/const/environment.dart';
import 'package:articles_flutter/features/products/domain/datasource/product_datasource.dart';
import 'package:articles_flutter/features/products/domain/entities/products.dart';
import 'package:articles_flutter/features/products/infrastructure/mappers/product_mapper.dart';
import 'package:dio/dio.dart';

class ProductDataSourceImpl implements ProductsDataSource {
  late final Dio dio;
  final String accessToken;

  /*
  Auth-Service tiene middleware que valida el token
  El token viene del provider
  */
  ProductDataSourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Enviroment.apiURL,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<List<Products>> getProducts() async {
    try {
      final response = await dio.get('/products');

      if (response.statusCode != 200) {
        throw Exception('Request failed with status: ${response.statusCode}');
      }

      final contentType = response.headers.map['content-type'];

      if (contentType == null ||
          (!contentType.contains('application/json') &&
              !contentType.contains('application/json; charset=utf-8'))) {
        throw Exception('Unexpected content type: $contentType');
      }

      final jsonData = response.data as List<dynamic>;
      final products = jsonData
          .map((data) => ProductsMapper.productsJsonToEntity(data))
          .toList();

      return products;
    } on DioException catch (e) {
      print('DioError: $e');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<Products>> getFavorites() {
    throw UnimplementedError();
  }

  @override
  Future<Products> addFavorite(
    String id,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Products> removeFavorite(
    String id,
  ) {
    throw UnimplementedError();
  }
}
