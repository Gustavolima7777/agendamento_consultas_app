import 'package:flutter/material.dart';

class ConsultasView extends StatelessWidget {
  const ConsultasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020818),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF1E88E5),
            child: Text(
              'G', // depois podemos puxar a inicial do usuário logado
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: const Text('Minha Agenda'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // futuramente: notificações
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Abas Dia / Semana (mock – por enquanto só "Dia" selecionado)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Dia',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF071427),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Semana',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Card do calendário
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF071427),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  // topo: mês + setas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.chevron_left, color: Colors.white70),
                      Text(
                        'Outubro 2024',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // cabeçalho dos dias da semana
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _DiaSemana('DOM'),
                      _DiaSemana('SEG'),
                      _DiaSemana('TER'),
                      _DiaSemana('QUA'),
                      _DiaSemana('QUI'),
                      _DiaSemana('SEX'),
                      _DiaSemana('SAB'),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // grade de dias (mock)
                  _CalendarioMes(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Agendamentos para Hoje, 24 de Outubro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Lista de consultas do dia
            Expanded(
              child: ListView(
                children: const [
                  _ConsultaCard(
                    corIndicador: Color(0xFF2ECC71),
                    horario: '14:00 - 15:00',
                    titulo: 'Consulta de Rotina',
                    subtitulo: 'Ana Silva',
                  ),
                  _ConsultaCard(
                    corIndicador: Color(0xFFFFA726),
                    horario: '16:00 - 16:30',
                    titulo: 'Retorno',
                    subtitulo: 'Carlos Pereira',
                  ),
                  _ConsultaCard(
                    corIndicador: Color(0xFFE57373),
                    horario: '17:00 - 18:00',
                    titulo: 'Horário Bloqueado',
                    subtitulo: 'Pausa para almoço',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiaSemana extends StatelessWidget {
  final String texto;

  const _DiaSemana(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CalendarioMes extends StatelessWidget {
  const _CalendarioMes();

  @override
  Widget build(BuildContext context) {
    final dias = List.generate(30, (i) => i + 1);

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: dias.map((dia) {
          final bool selecionado = dia == 24;

          return SizedBox(
            width: 32,
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                color:
                selecionado ? const Color(0xFF1E88E5) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                '$dia',
                style: TextStyle(
                  color: selecionado ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight:
                  selecionado ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ConsultaCard extends StatelessWidget {
  final Color corIndicador;
  final String horario;
  final String titulo;
  final String subtitulo;

  const _ConsultaCard({
    required this.corIndicador,
    required this.horario,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF071427),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: corIndicador.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.event,
            color: corIndicador,
            size: 18,
          ),
        ),
        title: Text(
          horario,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitulo,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.more_vert,
          color: Colors.white70,
        ),
      ),
    );
  }
}
