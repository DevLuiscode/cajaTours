import 'package:dio/dio.dart';

import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDataSourceImple extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiurl,
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsontoEntity(response.data);
      return user;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsontoEntity(response.data);

      return user;
    } on WrongCredentials {
      throw WrongCredentials();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['message'] ?? ' credenciales incorrectas');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String name, String lastName, String email,
      String password, String confirPassword) async {
    if (password.length > 1 && confirPassword.length > 1) {
      if (password != confirPassword) {
        throw CustomError('contraseñas no coiciden');
      }
    }

    try {
      final response = await dio.post('/auth/register', data: {
        'name': name,
        'lastName': lastName,
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsontoEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data['message'] ?? 'ya existe');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }
      throw Exception(e);
    } catch (e) {
      throw Exception();
    }
  }
}
