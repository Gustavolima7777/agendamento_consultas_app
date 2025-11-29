class Consulta {
  final String id;
  final String medicoId;
  final String pacienteId; // usuário/paciente dono da consulta
  final DateTime dataHora;

  Consulta({
    required this.id,
    required this.medicoId,
    required this.pacienteId,
    required this.dataHora,
  });
}
