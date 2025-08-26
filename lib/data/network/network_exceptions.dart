class NetworkException implements Exception {
  final dynamic message;
  final dynamic prefix;

  NetworkException([this.message, this.prefix]);

  String convertIntoString() {
    return "$prefix$message";
  }
}

class FetchDataException extends NetworkException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends NetworkException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends NetworkException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
