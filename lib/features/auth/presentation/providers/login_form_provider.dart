//todo: hacer 3 cosas

//todo : 1- crear el estado del provider === state

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../shared/infrastructure/inputs/email.dart';
import '../../../shared/infrastructure/inputs/password.dart';
import 'providers.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosting;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosting = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosting,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosting: isFormPosting ?? this.isFormPosting,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
      LoginFormState:
      isPosting :$isPosting
      isFormPosting :$isFormPosting
      isValid :$isValid
      email :$email
      password :$password
''';
  }
}

//todo : 2- como implementamos un notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  LoginFormNotifier({
    required this.loginUserCallback,
  }) : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() async {
    _toucherEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  _toucherEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosting: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

// todo : 3- statenotifierProvider---- consumer afuerda
// al implementar el metodo de autodispose elimina los datos que estan en el formulario
// es decir, al momento que ponemos nuestros datos en el login gmail y contrasena
// los datos se quedan al momento de regresar a la pantalla o salir e ingresar a la misma
//pantalla, para ello el autodispose elimina o limia esos valores que se quedan en el form

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  //Todo: lo que se va hacer ahora es llamar al otro provider de auth_provider
  //a este provider
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});
