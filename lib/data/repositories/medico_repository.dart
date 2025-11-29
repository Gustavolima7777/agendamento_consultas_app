import '../../domain/entities/medico.dart';

class MedicoRepository {
  // Simulação temporária (mock)
  final List<Medico> _medicos = [
    Medico(id: "1", nome: "Dr. João Silva", especialidade: "Cardiologista"),
    Medico(id: "2", nome: "Dra. Ana Costa", especialidade: "Dermatologista"),
    Medico(id: "3", nome: "Dr. Paulo Mendes", especialidade: "Ortopedista"),
  ];

  Future<List<Medico>> listarMedicos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _medicos;
  }

  Future<Medico?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _medicos.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
