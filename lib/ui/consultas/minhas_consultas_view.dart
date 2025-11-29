import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class MinhasConsultasView extends StatefulWidget {
  const MinhasConsultasView({super.key});

  @override
  State<MinhasConsultasView> createState() => _MinhasConsultasViewState();
}

class _MinhasConsultasViewState extends State<MinhasConsultasView> {
  bool _mostrarProximas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020818),
        elevation: 0,
        centerTitle: true,
        title: const Text('Minhas Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Abas Próximas / Passadas
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _mostrarProximas = true;
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _mostrarProximas
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFF071427),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Próximas',
                        style: TextStyle(
                          color: _mostrarProximas
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _mostrarProximas = false;
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: !_mostrarProximas
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFF071427),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Passadas',
                        style: TextStyle(
                          color: !_mostrarProximas
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _mostrarProximas
                  ? _buildListaProximas(context)
                  : _buildListaPassadas(context),
            ),
          ],
        ),
      ),
    );
  }

  // === LISTA DE PRÓXIMAS CONSULTAS ===
  Widget _buildListaProximas(BuildContext context) {
    return ListView(
      children: [
        _ConsultaProximaCard(
          status: 'Confirmada',
          corStatus: const Color(0xFF2ECC71),
          nomeMedico: 'Dr. Carlos Andrade',
          especialidade: 'Cardiologia',
          data: 'Segunda, 25 de Outubro',
          hora: '14:00',
          local: 'Clínica Saúde Plena, Sala 101',
          onCancelar: () {
            // depois implementamos de verdade
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cancelar (mock)')),
            );
          },
          onReagendar: () {
            // por enquanto leva para lista de médicos
            Navigator.pushNamed(context, AppRoutes.medicoLista);
          },
        ),

        const SizedBox(height: 12),

        _ConsultaProximaCard(
          status: 'Confirmada',
          corStatus: const Color(0xFF2ECC71),
          nomeMedico: 'Dra. Ana Souza',
          especialidade: 'Dermatologia',
          data: 'Quarta, 27 de Outubro',
          hora: '16:00',
          local: 'Av. Principal, 123 - Sala 4',
          onCancelar: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cancelar (mock)')),
            );
          },
          onReagendar: () {
            Navigator.pushNamed(context, AppRoutes.medicoLista);
          },
        ),

        const SizedBox(height: 24),

        // Estado "Nenhuma consulta futura"
        Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF071427),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.event_busy,
                color: Colors.white70,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma consulta futura',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Você ainda não tem consultas agendadas.\nQue tal marcar uma agora?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.medicoLista);
                },
                child: const Text(
                  'Agendar Nova Consulta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  // === LISTA DE CONSULTAS PASSADAS (mock) ===
  Widget _buildListaPassadas(BuildContext context) {
    return ListView(
      children: const [
        _ConsultaPassadaCard(
          nomeMedico: 'Dr. Carlos Andrade',
          especialidade: 'Cardiologia',
          data: 'Segunda, 10 de Outubro',
          hora: '09:00',
          local: 'Clínica Saúde Plena, Sala 101',
        ),
        SizedBox(height: 12),
        _ConsultaPassadaCard(
          nomeMedico: 'Dra. Ana Souza',
          especialidade: 'Dermatologia',
          data: 'Quarta, 05 de Outubro',
          hora: '15:30',
          local: 'Av. Principal, 123 - Sala 4',
        ),
      ],
    );
  }
}

class _ConsultaProximaCard extends StatelessWidget {
  final String status;
  final Color corStatus;
  final String nomeMedico;
  final String especialidade;
  final String data;
  final String hora;
  final String local;
  final VoidCallback onCancelar;
  final VoidCallback onReagendar;

  const _ConsultaProximaCard({
    required this.status,
    required this.corStatus,
    required this.nomeMedico,
    required this.especialidade,
    required this.data,
    required this.hora,
    required this.local,
    required this.onCancelar,
    required this.onReagendar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF071427),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha de status + avatar do médico
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: corStatus.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: corStatus,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: corStatus,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF1E88E5),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              nomeMedico,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              especialidade,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  data,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  hora,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    local,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: onCancelar,
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: onReagendar,
                    child: const Text(
                      'Reagendar',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultaPassadaCard extends StatelessWidget {
  final String nomeMedico;
  final String especialidade;
  final String data;
  final String hora;
  final String local;

  const _ConsultaPassadaCard({
    required this.nomeMedico,
    required this.especialidade,
    required this.data,
    required this.hora,
    required this.local,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF071427),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeMedico,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              especialidade,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  data,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  hora,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 15, color: Colors.white54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    local,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  // depois: tela de detalhes da consulta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ver detalhes (mock)')),
                  );
                },
                child: const Text(
                  'Ver detalhes',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
