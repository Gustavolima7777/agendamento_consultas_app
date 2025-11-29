import 'package:flutter/material.dart';

import '../data/repositories/consulta_repository.dart';
import '../data/repositories/usuario_repository.dart';
import '../domain/entities/consulta.dart';

class ConsultaViewModel extends ChangeNotifier {
  final ConsultaRepository consultaRepository;
  final UsuarioRepository usuarioRepository;

  ConsultaViewModel({
    required this.consultaRepository,
    required this.usuarioRepository,
  });

  List<Consulta> consultas = [];
  bool loading = false;
  String? erro;
  bool isAdmin = false; // exposto para a tela saber o perfil

  Future<void> carregarConsultas() async {
    loading = true;
    erro = null;
    notifyListeners();

    try {
      final usuario = await usuarioRepository.obterUsuario();

      if (usuario == null) {
        erro = 'Nenhum usuário logado.';
        loading = false;
        notifyListeners();
        return;
      }

      isAdmin = usuario.role == 'ADMIN';

      final resultado = await consultaRepository.listarConsultas(
        pacienteId: isAdmin ? null : usuario.id,
        isAdmin: isAdmin,
      );

      consultas = resultado;
    } catch (e) {
      erro = 'Erro ao carregar consultas.';
    }

    loading = false;
    notifyListeners();
  }

  /// Agenda uma nova consulta para o usuário logado
  Future<bool> agendarConsulta({
    required String medicoId,
    required DateTime dataHora,
  }) async {
    erro = null;
    notifyListeners();

    try {
      final usuario = await usuarioRepository.obterUsuario();
      if (usuario == null) {
        erro = 'Nenhum usuário logado.';
        notifyListeners();
        return false;
      }

      final nova = Consulta(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicoId: medicoId,
        pacienteId: usuario.id,
        dataHora: dataHora,
      );

      await consultaRepository.adicionarConsulta(nova);

      // Atualiza lista local (para já aparecer em Consultas Marcadas)
      consultas = await consultaRepository.listarConsultas(
        pacienteId: isAdmin ? null : usuario.id,
        isAdmin: isAdmin,
      );

      notifyListeners();
      return true;
    } catch (e) {
      erro = 'Erro ao agendar consulta.';
      notifyListeners();
      return false;
    }
  }
}
