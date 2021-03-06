enum UiError {
  requiredField,
  invalidadField,
  unexpected,
  invalidCredentials,
}

extension UiErrorErrorExtension on UiError {
  String get description {
    switch (this) {
      // this is the enum UiError
      case UiError.requiredField:
        return 'Campo obrigatório.';

      case UiError.invalidadField:
        return 'Campo inválido.';

      case UiError.invalidCredentials:
        return 'Credenciais inválidas.';

      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}
