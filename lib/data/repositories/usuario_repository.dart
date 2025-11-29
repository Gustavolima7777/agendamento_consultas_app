import '../../domain/entities/usuario.dart';

class UsuarioRepository {
  /// Usuário "logado" em memória (mock)
  Usuario? _usuarioAtual;

  /// Salva o usuário após o login
  Future<void> salvarUsuario(Usuario usuario) async {
    _usuarioAtual = usuario;
  }

  /// Retorna o usuário atual se já tiver sido salvo
  Future<Usuario?> obterUsuario() async {
    return _usuarioAtual;
  }

  /// Usado pelo PerfilViewModel para buscar dados do usuário
  /// Se não tiver ninguém salvo ainda, devolve um mock de Paciente
  Future<Usuario> buscarUsuarioAtual() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_usuarioAtual != null) {
      return _usuarioAtual!;
    }

    // Mock padrão (paciente)
    return Usuario(
      id: '1',
      nome: 'Paciente Teste',
      email: 'paciente@test.com',
      role: 'PACIENTE',
      tipo: 'Paciente',
    );
  }
}
