import 'translations.dart';

class PtBr implements Translations {
  String get msgRequiredField => 'Campo obrigatório.';
  String get msgInvalidField => 'Campo inválido.';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';

  String get addAccount => 'Criar conta';
  String get email => 'Email';
  String get signIn => 'Entrar';
  String get password => 'Senha';
  String get confirmPassword => 'Confirmar senha';
  String get login => 'Login';
  String get name => 'Nome';
  String get wait => 'Aguarde...';
}
