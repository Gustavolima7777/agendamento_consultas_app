import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

  bool loading = false;
  String? erro;

  /// Dia selecionado na agenda
  DateTime selectedDate = DateTime.now();

  /// Consultas do dia selecionado
  List<Consulta> consultasDia = [];

  StreamSubscription<List<Consulta>>? _subscriptionAtual;

  /// Obtém o ID do paciente logado
  Future<String?> _obterPacienteId() async {
    final usuario = await usuarioRepository.obterUsuario();

    if (usuario == null) {
      erro = 'Usuário não encontrado.';
      notifyListeners();
      return null;
    }

    return usuario.id;
  }

  /// Inicia a escuta das consultas do dia para o usuário logado
  Future<void> initAgenda() async {
    final pacienteId = await _obterPacienteId();
    if (pacienteId == null) return;

    _ouvirConsultasDoDia(pacienteId: pacienteId);
  }

  /// Troca a data no calendário e atualiza as consultas do dia
  Future<void> selecionarData(DateTime novaData) async {
    selectedDate = novaData;
    notifyListeners();

    final pacienteId = await _obterPacienteId();
    if (pacienteId == null) return;

    _ouvirConsultasDoDia(pacienteId: pacienteId);
  }

  void _ouvirConsultasDoDia({required String pacienteId}) {
    _subscriptionAtual?.cancel();

    final stream = consultaRepository.consultasDoDiaStream(
      pacienteId: pacienteId,
      dia: selectedDate,
    );

    _subscriptionAtual = stream.listen((lista) {
      consultasDia = lista;
      notifyListeners();
    });
  }

  /// Agenda uma nova consulta para o usuário logado
  Future<void> agendarConsulta({
    required String medicoId,
    required DateTime dataHora,
  }) async {
    try {
      loading = true;
      erro = null;
      notifyListeners();

      final pacienteId = await _obterPacienteId();
      if (pacienteId == null) {
        loading = false;
        notifyListeners();
        return;
      }

      // NÃO deixa agendar para data passada
      final agora = DateTime.now();
      final hoje = DateTime(agora.year, agora.month, agora.day);
      final diaConsulta = DateTime(
        dataHora.year,
        dataHora.month,
        dataHora.day,
      );

      if (diaConsulta.isBefore(hoje)) {
        erro = 'Não é possível agendar para uma data passada.';
        loading = false;
        notifyListeners();
        return;
      }

      final consulta = Consulta(
        id: const Uuid().v4(),
        medicoId: medicoId,
        pacienteId: pacienteId,
        dataHora: dataHora,
      );

      await consultaRepository.criarConsulta(consulta);

      // Recarrega as consultas do dia selecionado
      _ouvirConsultasDoDia(pacienteId: pacienteId);
    } catch (e) {
      erro = 'Erro ao agendar consulta';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscriptionAtual?.cancel();
    super.dispose();
  }
}
