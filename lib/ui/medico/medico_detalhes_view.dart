import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class MedicoDetalhesView extends StatelessWidget {
  const MedicoDetalhesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Recebendo dados do médico vindos da lista
    final Map<String, String> medico =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(medico["nome"]!),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 60, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              medico["nome"]!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Especialidade: ${medico["especialidade"]!}",
              style: const TextStyle(fontSize: 18),
            ),

            const Spacer(),

            // Botão de agendar consulta
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.agenda,
                    arguments: medico,
                  );
                },
                child: const Text(
                  "Agendar Consulta",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botão de chat com profissional
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chat,
                    arguments: medico,
                  );
                },
                child: const Text(
                  "Tirar dúvidas (Chat)",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
