// Define input validation errors
import 'package:formz/formz.dart';

enum NameError { empty }

// Extend FormzInput for the name

class Name extends FormzInput<String, NameError> {
  const Name.pure() : super.pure('');
  const Name.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    // Aquí puedes agregar otras reglas de validación para un "nombre" válido.
    return null;
  }
}
