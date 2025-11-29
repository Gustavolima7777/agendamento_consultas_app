import '../../domain/entities/mensagem_chat.dart';

class ChatRepository {
  // chatId -> lista de mensagens
  final Map<String, List<MensagemChat>> _chats = {};

  Future<List<MensagemChat>> listarMensagens(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final lista = _chats[chatId] ?? [];
    return List.unmodifiable(lista);
  }

  Future<void> enviarMensagem(MensagemChat mensagem) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final lista = _chats.putIfAbsent(mensagem.chatId, () => []);
    lista.add(mensagem);
  }
}
