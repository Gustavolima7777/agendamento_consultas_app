import 'package:flutter/material.dart';

import '../data/repositories/chat_repository.dart';
import '../data/repositories/usuario_repository.dart';
import '../domain/entities/mensagem_chat.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository chatRepository;
  final UsuarioRepository usuarioRepository;

  ChatViewModel({
    required this.chatRepository,
    required this.usuarioRepository,
  });

  final TextEditingController mensagemController = TextEditingController();

  String? _chatId;
  String? _usuarioId;

  List<MensagemChat> mensagens = [];
  bool loading = false;
  String? erro;

  Future<void> initChat({required String medicoId}) async {
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

      _usuarioId = usuario.id;
      // chatId simples: pacienteId_medicoId
      _chatId = '${usuario.id}_$medicoId';

      mensagens = await chatRepository.listarMensagens(_chatId!);
    } catch (e) {
      erro = 'Erro ao carregar mensagens.';
    }

    loading = false;
    notifyListeners();
  }

  Future<void> enviarMensagem() async {
    final texto = mensagemController.text.trim();
    if (texto.isEmpty || _chatId == null || _usuarioId == null) return;

    final novaMensagem = MensagemChat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: _chatId!,
      remetenteId: _usuarioId!,
      texto: texto,
      dataHora: DateTime.now(),
    );

    mensagemController.clear();

    await chatRepository.enviarMensagem(novaMensagem);
    mensagens = await chatRepository.listarMensagens(_chatId!);
    notifyListeners();
  }

  bool mensagemEhDoUsuario(MensagemChat msg) {
    return msg.remetenteId == _usuarioId;
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }
}
