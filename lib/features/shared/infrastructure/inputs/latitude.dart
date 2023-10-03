// Define input validation errors

import 'package:formz/formz.dart';

enum LatitudeError { empty, invalid }

class Latitude extends FormzInput<String, LatitudeError> {
  const Latitude.pure() : super.pure('');
  const Latitude.dirty([String value = '']) : super.dirty(value);

  @override
  LatitudeError? validator(String? value) {
    if (value == null || value.isEmpty) return LatitudeError.empty;
    if (double.tryParse(value) == null) return LatitudeError.invalid;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case LatitudeError.empty:
        return 'El campo no debe estar vacío';
      case LatitudeError.invalid:
        return 'Ingrese un número válido';
      default:
        return null;
    }
  }
}
