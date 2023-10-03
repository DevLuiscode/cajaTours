import '../entities/user.dart';

abstract class AuthRepository {
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
