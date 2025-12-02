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

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicoId': medicoId,
      'pacienteId': pacienteId,
      'dataHora': dataHora.toIso8601String(),
    };
  }

  // Converter de Map (para ler do Firestore)
  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'] ?? '',
      medicoId: map['medicoId'] ?? '',
      pacienteId: map['pacienteId'] ?? '',
      dataHora: DateTime.parse(map['dataHora']),
    );
  }
}
