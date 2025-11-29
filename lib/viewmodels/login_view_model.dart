import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/usuario_repository.dart';
import '../domain/entities/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final UsuarioRepository usuarioRepository;

  LoginViewModel({
    required this.authRepository,
    required this.usuarioRepository,
  });

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool _loading = false;
  String? _erro;
  Usuario? _usuario;

  bool get loading => _loading;
  String? get erro => _erro;
  Usuario? get usuario => _usuario;

  Future<Usuario?> login() async {
    _loading = true;
    _erro = null;
    notifyListeners();

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    final user = await authRepository.login(email, senha);

    _loading = false;

    if (user == null) {
      _erro = 'E-mail ou senha inválidos';
      notifyListeners();
      return null;
    }

    // salva o usuário logado para o resto do app (perfil, admin, etc.)
    await usuarioRepository.salvarUsuario(user);

    _usuario = user;
    notifyListeners();
    return user;
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
