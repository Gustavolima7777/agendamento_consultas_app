import '../../domain/entities/consulta.dart';

class ConsultaRepository {
  // Mock de consultas (algumas do paciente id '2', outras de outros)
  final List<Consulta> _consultas = [
    Consulta(
      id: '1',
      medicoId: '1',
      pacienteId: '2', // paciente teste
      dataHora: DateTime(2025, 1, 10, 14, 0),
    ),
    Consulta(
      id: '2',
      medicoId: '2',
      pacienteId: '2', // paciente teste
      dataHora: DateTime(2025, 1, 12, 9, 30),
    ),
    Consulta(
      id: '3',
      medicoId: '1',
      pacienteId: '3', // outro paciente qualquer
      dataHora: DateTime(2025, 1, 15, 16, 0),
    ),
  ];

  Future<List<Consulta>> listarConsultas({
    String? pacienteId,
    bool isAdmin = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (isAdmin || pacienteId == null) {
      // admin vê tudo
      return List.unmodifiable(_consultas);
    }

    // paciente vê só as dele
    return _consultas
        .where((c) => c.pacienteId == pacienteId)
        .toList(growable: false);
  }

  Future<void> adicionarConsulta(Consulta consulta) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _consultas.add(consulta);
  }
}
