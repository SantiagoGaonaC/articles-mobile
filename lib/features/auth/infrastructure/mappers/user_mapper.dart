

import 'package:articles_flutter/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        statusCode: json['statusCode'],
        message: json['message'],
        token: json['token']);
  }
}
