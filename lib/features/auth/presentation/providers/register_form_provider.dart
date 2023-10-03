//State de este provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import 'package:teslo_shop/features/shared/shared.dart';

class RegisterFormState {
  final bool isPosting; // para saber si estoy posteando
  final bool isFormPosting; //para saber si la persona intento postear
  final bool isValid;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final Name name;
  final LastName lastname;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosting = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.name = const Name.pure(),
    this.lastname = const LastName.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosting,
    bool? isValid,
    Email? email,
    Password? password,
    Password? confirmPassword,
    Name? name,
    LastName? lastname,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosting: isFormPosting ?? this.isFormPosting,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
      );

  @override
  String toString() {
    return '''
    RegisterFormState: 
    isPosting : $isPosting
    isFormPosting : $isFormPosting
    isValid : $isValid
    email : $email
    password : $password
    confirmPassword: $confirmPassword,
    name : $name
    lastname : $lastname
''';
  }
}

// notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String, String, String) registerCallback;

  RegisterFormNotifier({
    required this.registerCallback,
  }) : super(RegisterFormState());

  onNameChange(String value) {
    final newName = Name.dirty(value);

    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([
        newName,
        state.lastname,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    );
  }

  onLastNameChange(String value) {
    final newLastName = LastName.dirty(value);

    state = state.copyWith(
      lastname: newLastName,
      isValid: Formz.validate([
        newLastName,
        state.name,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        newEmail,
        state.name,
        state.lastname,
        state.password,
        state.confirmPassword
      ]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate(
        [
          newPassword,
          state.name,
          state.lastname,
          state.email,
          state.confirmPassword,
        ],
      ),
    );
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = Password.dirty(value);

    state = state.copyWith(
        confirmPassword: newConfirmPassword,
        isValid: Formz.validate([
          newConfirmPassword,
          state.name,
          state.lastname,
          state.email,
          state.password,
        ]));
  }

  onFormSubmit() async {
    _onToucheEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerCallback(
      state.name.value,
      state.lastname.value,
      state.email.value,
      state.password.value,
      state.confirmPassword.value,
    );

    state = state.copyWith(isPosting: false);
  }

  _onToucheEveryField() {
    final name = Name.dirty(state.name.value);
    final lastName = LastName.dirty(state.lastname.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    state = state.copyWith(
        isFormPosting: true,
        name: name,
        lastname: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate(
          [
            name,
            lastName,
            email,
            password,
            confirmPassword,
          ],
        ));
  }
}

// ahora se va asignado el provider
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUser = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerCallback: registerUser);
});
