class MensagemChat {
  final String id;
  final String chatId;
  final String remetenteId; // id de quem enviou
  final String texto;
  final DateTime dataHora;

  MensagemChat({
    required this.id,
    required this.chatId,
    required this.remetenteId,
    required this.texto,
    required this.dataHora,
  });
}
