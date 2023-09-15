

//implementación de la definición del datasource que se va a usar para el auth
import 'package:articles_flutter/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password); //add more test
  Future<User> checkAuthStatus(String token);
}
