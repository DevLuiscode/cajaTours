class WrongCredentials implements Exception {}

class InvilidToken implements Exception {}

class ErrorRegister implements Exception {}

class EmailYaRegitrado implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;

  CustomError(this.message);
}
