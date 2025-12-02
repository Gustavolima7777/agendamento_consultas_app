import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class MedicoDetalhesView extends StatelessWidget {
  const MedicoDetalhesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Agora usamos Map<String, dynamic> (compatível com o arguments que vem da lista)
    final medico =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final nome = (medico['nome'] ?? 'Profissional') as String;
    final especialidade = (medico['especialidade'] ?? '') as String;
    final local = (medico['local'] ?? 'Atendimento online') as String;

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: Text(
          nome,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar + nome + especialidade
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFF1D4ED8),
                  child: Icon(Icons.person, color: Colors.white, size: 34),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        especialidade,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Local / info extra
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1020),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.white70, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      local,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Opções',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            // Botão: Agendar Consulta
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.agenda,
                    arguments: medico, // passa o mesmo map adiante
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'Agendar Consulta',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botão: Tirar dúvidas (Chat)
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chat,
                    arguments: medico,
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1020),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'Tirar dúvidas (Chat)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const Spacer(),

            const Text(
              'Lembrete: este chat é apenas para dúvidas rápidas. '
                  'Em caso de emergência, procure um hospital.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
