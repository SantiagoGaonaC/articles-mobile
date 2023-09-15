

import 'package:articles_flutter/features/auth/domain/domain.dart';

abstract class AuthDataSource {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password); //add more test
  Future<User> checkAuthStatus(String token);
}
