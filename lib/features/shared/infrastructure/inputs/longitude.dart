import 'package:formz/formz.dart';

enum LongitudeError { empty, invalid }

class Longitude extends FormzInput<String, LongitudeError> {
  const Longitude.pure() : super.pure('');
  const Longitude.dirty([String value = '']) : super.dirty(value);

  @override
  LongitudeError? validator(String? value) {
    if (value == null || value.isEmpty) return LongitudeError.empty;
    if (double.tryParse(value) == null) return LongitudeError.invalid;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case LongitudeError.empty:
        return 'El campo no debe estar vacío';
      case LongitudeError.invalid:
        return 'Ingrese un número válido';
      default:
        return null;
    }
  }
}
