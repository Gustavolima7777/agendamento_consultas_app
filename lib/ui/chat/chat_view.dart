import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();

  // Mock de mensagens (vai sumir quando fechar o app, é só visual)
  final List<_Mensagem> _mensagens = [
    _Mensagem(
      texto:
      'Olá! Como posso ajudar hoje? Lembre-se, este chat é para esclarecermos dúvidas. Em caso de emergência, procure um hospital.',
      horario: '14:28',
      ehUsuario: false,
    ),
    _Mensagem(
      texto:
      'Olá, Dra. Ana! Tenho uma dúvida rápida sobre o medicamento que me receitou.',
      horario: '14:30',
      ehUsuario: true,
    ),
    _Mensagem(
      texto: 'Claro, pode perguntar.',
      horario: '14:31',
      ehUsuario: false,
    ),
    _Mensagem(
      texto:
      'Posso tomar o analgésico junto com o anti-inflamatório?',
      horario: '14:32',
      ehUsuario: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final medicoArgs =
    ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final nomeMedico = medicoArgs?['nome'] ?? 'Profissional';

    return Scaffold(
      backgroundColor: const Color(0xFF020818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020818),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF1E88E5),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeMedico,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Icon(Icons.circle,
                          size: 8, color: Color(0xFF2ECC71)),
                      SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Chip "Hoje"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF071427),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Hoje',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final msg = _mensagens[index];
                final alinhamento = msg.ehUsuario
                    ? Alignment.centerRight
                    : Alignment.centerLeft;

                final corBolha = msg.ehUsuario
                    ? const Color(0xFF1E88E5)
                    : const Color(0xFF071427);

                final borda = msg.ehUsuario
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                );

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment: alinhamento,
                  child: Column(
                    crossAxisAlignment: msg.ehUsuario
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 260,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: corBolha,
                          borderRadius: borda,
                        ),
                        child: Text(
                          msg.texto,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        msg.horario,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Campo de mensagem
          SafeArea(
            top: false,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xFF020818),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071427),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Digite sua mensagem',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _enviarMensagem,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enviarMensagem() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensagens.add(
        _Mensagem(
          texto: texto,
          horario: _horaAtual(),
          ehUsuario: true,
        ),
      );
    });
    _controller.clear();
  }

  String _horaAtual() {
    final agora = DateTime.now();
    final h = agora.hour.toString().padLeft(2, '0');
    final m = agora.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _Mensagem {
  final String texto;
  final String horario;
  final bool ehUsuario;

  _Mensagem({
    required this.texto,
    required this.horario,
    required this.ehUsuario,
  });
}
