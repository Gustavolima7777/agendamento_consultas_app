import 'package:flutter/material.dart';

import '../data/repositories/medico_repository.dart';
import '../domain/entities/medico.dart';

class MedicoViewModel extends ChangeNotifier {
  final MedicoRepository medicoRepository;

  MedicoViewModel({required this.medicoRepository});

  bool _loading = false;
  String? _erro;
  List<Medico> _medicos = [];

  bool get loading => _loading;
  String? get erro => _erro;
  List<Medico> get medicos => _medicos;

  Future<void> carregarMedicos() async {
    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      _medicos = await medicoRepository.listarMedicos();
    } catch (e) {
      _erro = 'Erro ao carregar médicos';
    }

    _loading = false;
    notifyListeners();
  }
}
