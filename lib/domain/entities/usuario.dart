class Usuario {
  final String id;
  final String nome;
  final String email;

  /// Papel técnico: usado para regras de negócio / decisões
  /// Valores: 'ADMIN' ou 'PACIENTE'
  final String role;

  /// Texto amigável exibido na interface: 'Administrador', 'Paciente'
  final String tipo;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.role,
    required this.tipo,
  });
}
