import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/infrastructure/services/key_value_storage.dart';
import '../../../shared/infrastructure/services/key_value_storage_impl.dart';
import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

enum AuthStatus { checking, authenticated, notAunthenticated }

enum RegisterStatus { register, noRegister }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessages;
  final String exitoMessages;
  final RegisterStatus registerStatus;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessages = '',
    this.exitoMessages = '',
    this.registerStatus = RegisterStatus.noRegister,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessages,
    String? exitoMessages,
    RegisterStatus? registerStatus,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessages: errorMessages ?? this.errorMessages,
        exitoMessages: exitoMessages ?? this.exitoMessages,
        registerStatus: registerStatus ?? this.registerStatus,
      );
}

//TODO : Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorage,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);

      _setLogUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('error no controlado');
    }
  }

  Future<void> registerUser(String name, String lastName, String email,
      String password, String confirPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.register(
        name,
        lastName,
        email,
        password,
        confirPassword,
      );
      _setRegister(user);
    } on CustomError catch (e) {
      noRegister(e.message);
      throw CustomError(e.message);
    } catch (e) {
      throw Exception();
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorage.getKeyValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLogUser(user);
    } catch (e) {
      logout();
    }
  }

  _setLogUser(User user) async {
    // necesito guardar el token fisicamente
    await keyValueStorage.setKeyValue('token', user.token);
    state = state.copyWith(
        user: user,
        authStatus: AuthStatus.authenticated,
        errorMessages: 'Iniciando sesion');
  }

  Future<void> _setRegister(User user) async {
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessages: 'Usuario Registrado',
    );
  }

  Future<void> logout([String? errorMenssages]) async {
    //limpiar token
    await keyValueStorage.removeKeyValue('token');
    state = state.copyWith(
      authStatus: AuthStatus.notAunthenticated,
      user: null,
      errorMessages: errorMenssages,
    );
  }

  Future<void> noRegister([String? errorMenssages]) async {
    state = state.copyWith(
      authStatus: AuthStatus.notAunthenticated,
      errorMessages: errorMenssages,
    );
  }
}

//TODO : Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoriesImpl();

  final keyValueStorageService = KeyValueStorageImp();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorage: keyValueStorageService,
  );
});
