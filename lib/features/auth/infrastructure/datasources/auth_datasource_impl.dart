import 'package:articles_flutter/config/const/environment.dart';
import 'package:articles_flutter/features/auth/domain/domain.dart';
import 'package:articles_flutter/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:articles_flutter/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token wrong');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String username, String password) async {
    try {
      final responde = await dio
          .post('/login', data: {'username': username, 'password': password});

      final user = UserMapper.userJsonToEntity(responde.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Credentials wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String username, String password) {
    // TODO: implementación de register para cuando lo necesite
    throw UnimplementedError();
  }
}
