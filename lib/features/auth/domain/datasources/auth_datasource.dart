import 'package:teslo_shop/features/products/domain/entities/commet.dart';

import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(
    String name,
    String lastName,
    String email,
    String password,
    String confirPassword,
  );

  Future<User> checkAuthStatus(String token);
}
