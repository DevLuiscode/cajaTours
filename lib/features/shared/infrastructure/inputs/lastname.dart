import 'package:formz/formz.dart';

enum LastNameError { empty }

class LastName extends FormzInput<String, LastNameError> {
  const LastName.pure() : super.pure('');
  const LastName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == LastNameError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  LastNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return LastNameError.empty;
    // Aquí puedes agregar otras reglas de validación para un "apellido" válido.
    return null;
  }
}
