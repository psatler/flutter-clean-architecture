import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  AuthenticationParams({
    @required this.email,
    @required this.password,
  });

  // to compare for equality between two objects
  @override
  List<Object> get props => [email, password];
}
