abstract class IException implements Exception {
  final String message;

  IException(this.message);

  @override
  String toString() {
    return message;
  
  }
}

class RuntimeException extends IException {
  RuntimeException(String message) : super(message);
}

class IllegalArgumentException extends IException {
  IllegalArgumentException(String message) : super(message);
}

class InvalidVertexException extends IException {
  InvalidVertexException(String message) : super(message);
}
