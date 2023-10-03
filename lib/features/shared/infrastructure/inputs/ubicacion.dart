// Define input validation errors
import 'package:formz/formz.dart';

enum UbicacionError { empty }

// Extend FormzInput for the name

class Ubicacion extends FormzInput<String, UbicacionError> {
  const Ubicacion.pure() : super.pure('');
  const Ubicacion.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UbicacionError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  UbicacionError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UbicacionError.empty;
    // Aquí puedes agregar otras reglas de validación para un "nombre" válido.
    return null;
  }
}
