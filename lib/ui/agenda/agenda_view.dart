import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/consulta_view_model.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late Map<String, dynamic> medico;

  final List<String> _horarios = ['09:00', '10:30', '14:00', '16:00'];
  String? _horarioSelecionado;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    medico = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Inicia ouvindo as consultas do dia para o usuário logado
    context.read<ConsultaViewModel>().initAgenda();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsultaViewModel>();

    final consultasDoDia = vm.consultasDia;
    final dataSelecionada = vm.selectedDate;

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text(
          'Minha Agenda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho com info do médico
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF2563EB),
                  child: Icon(Icons.person, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (medico['nome'] ?? 'Profissional') as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (medico['especialidade'] ?? '') as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Calendário
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0B1020),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CalendarDatePicker(
                initialDate: dataSelecionada,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  context.read<ConsultaViewModel>().selecionarData(date);
                },
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Horários disponíveis',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _horarios.map((hora) {
                final selecionado = _horarioSelecionado == hora;
                return ChoiceChip(
                  label: Text(hora),
                  selected: selecionado,
                  onSelected: (_) {
                    setState(() {
                      _horarioSelecionado = hora;
                    });
                  },
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFF0B1020),
                  labelStyle: TextStyle(
                    color: selecionado ? Colors.white : Colors.white70,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            const Text(
              'Consultas do dia',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: consultasDoDia.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhuma consulta para este dia.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
                  : ListView.builder(
                itemCount: consultasDoDia.length,
                itemBuilder: (context, index) {
                  final c = consultasDoDia[index];
                  final data = c.dataHora;
                  final horaFormatada =
                      '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1020),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.event_available,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Consulta - $horaFormatada',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${data.day.toString().padLeft(2, '0')}/'
                                    '${data.month.toString().padLeft(2, '0')}/'
                                    '${data.year}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Botão Confirmar agendamento
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: (_horarioSelecionado == null || vm.loading)
                    ? null
                    : () async {
                  final data = vm.selectedDate;
                  final partes = _horarioSelecionado!.split(':');
                  final h = int.parse(partes[0]);
                  final m = int.parse(partes[1]);

                  final dataHora = DateTime(
                    data.year,
                    data.month,
                    data.day,
                    h,
                    m,
                  );

                  final medicoId =
                  (medico['id'] ?? medico['nome'] ?? 'medico_teste')
                      .toString();

                  await vm.agendarConsulta(
                    medicoId: medicoId,
                    dataHora: dataHora,
                  );

                  if (!mounted) return;

                  if (vm.erro != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vm.erro!)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                        Text('Consulta agendada com sucesso!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: vm.loading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Confirmar agendamento',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
