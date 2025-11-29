import 'dart:async';

import '../../domain/entities/usuario.dart';

class AuthService {
  /// Mock de login
  /// - admin@test.com / 123  -> ADMIN
  /// - paciente@test.com / 123 -> PACIENTE
  Future<Usuario?> login(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'admin@test.com' && senha == '123') {
      return Usuario(
        id: '1',
        nome: 'Administrador',
        email: email,
        role: 'ADMIN',
        tipo: 'Administrador',
      );
    }

    if (email == 'paciente@test.com' && senha == '123') {
      return Usuario(
        id: '2',
        nome: 'Paciente Teste',
        email: email,
        role: 'PACIENTE',
        tipo: 'Paciente',
      );
    }

    // credenciais inválidas
    return null;
  }
}
