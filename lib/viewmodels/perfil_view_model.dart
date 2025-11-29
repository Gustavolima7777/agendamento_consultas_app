import 'package:flutter/material.dart';

import '../data/repositories/usuario_repository.dart';
import '../domain/entities/usuario.dart';
import '../core/app_routes.dart';

class PerfilViewModel extends ChangeNotifier {
  final UsuarioRepository usuarioRepository;

  PerfilViewModel({required this.usuarioRepository});

  Usuario? _usuario;
  bool loading = false;
  String? erro;

  // Loading específico do botão "Sair"
  bool _loadingLogout = false;
  bool get loadingLogout => _loadingLogout;

  /// Getter seguro: se ainda não tiver usuário carregado,
  /// devolve um mock básico de paciente só para não quebrar a UI.
  Usuario get usuario => _usuario ??
      Usuario(
        id: '',
        nome: 'Usuário',
        email: '',
        role: 'PACIENTE',
        tipo: 'Paciente',
      );

  bool get isAdmin => usuario.role == 'ADMIN';

  Future<void> carregarUsuario() async {
    try {
      loading = true;
      erro = null;
      notifyListeners();

      _usuario = await usuarioRepository.buscarUsuarioAtual();

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      erro = 'Erro ao carregar perfil';
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      _loadingLogout = true;
      notifyListeners();

      // Se depois você quiser limpar algo no repositório, pode usar aqui:
      // await usuarioRepository.limparUsuario();

      // Navega para o login limpando a pilha de rotas
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } finally {
      _loadingLogout = false;
      notifyListeners();
    }
  }
}
