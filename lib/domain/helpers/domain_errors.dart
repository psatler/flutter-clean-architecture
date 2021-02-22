enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      // this is the enum DomainError
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';

      default:
        return '';
    }
  }
}
