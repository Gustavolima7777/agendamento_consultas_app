import '../services/auth_service.dart';
import '../../domain/entities/usuario.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<Usuario?> login(String email, String senha) {
    return authService.login(email, senha);
  }
}

