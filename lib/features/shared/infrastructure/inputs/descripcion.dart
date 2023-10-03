// Define input validation errors
import 'package:formz/formz.dart';

enum DescripcionError { empty }

// Extend FormzInput for the name

class Descripcion extends FormzInput<String, DescripcionError> {
  const Descripcion.pure() : super.pure('');
  const Descripcion.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DescripcionError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  DescripcionError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return DescripcionError.empty;
    // Aquí puedes agregar otras reglas de validación para un "nombre" válido.
    return null;
  }
}
