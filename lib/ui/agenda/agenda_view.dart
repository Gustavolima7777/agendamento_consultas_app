import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../viewmodels/consulta_view_model.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );

    if (date != null) {
      setState(() {
        _dataSelecionada = date;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (time != null) {
      setState(() {
        _horaSelecionada = time;
      });
    }
  }

  Future<void> _confirmarAgendamento(Map<String, String> medico) async {
    if (_dataSelecionada == null || _horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione data e horário para agendar.'),
        ),
      );
      return;
    }

    final vm = context.read<ConsultaViewModel>();

    final dataHora = DateTime(
      _dataSelecionada!.year,
      _dataSelecionada!.month,
      _dataSelecionada!.day,
      _horaSelecionada!.hour,
      _horaSelecionada!.minute,
    );

    final medicoId = medico['id'] ?? '1';

    final ok = await vm.agendarConsulta(
      medicoId: medicoId,
      dataHora: dataHora,
    );

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.erro ?? 'Falha ao agendar consulta.'),
        ),
      );
      return;
    }

    final data =
        "${dataHora.day.toString().padLeft(2, '0')}/"
        "${dataHora.month.toString().padLeft(2, '0')}/"
        "${dataHora.year}";
    final hora =
        "${dataHora.hour.toString().padLeft(2, '0')}:"
        "${dataHora.minute.toString().padLeft(2, '0')}";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Consulta com ${medico['nome']} agendada para $data às $hora.",
        ),
      ),
    );

    // Vai para a tela de Consultas Marcadas
    Navigator.pushReplacementNamed(context, AppRoutes.consultas);
  }

  @override
  Widget build(BuildContext context) {
    final medico =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    final nomeMedico = medico?['nome'] ?? 'Médico';
    final especialidade = medico?['especialidade'] ?? 'Especialidade';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consulta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomeMedico,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              especialidade,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            const Text(
              'Selecione a data:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selecionarData,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _dataSelecionada == null
                          ? 'Toque para escolher a data'
                          : "${_dataSelecionada!.day.toString().padLeft(2, '0')}/"
                          "${_dataSelecionada!.month.toString().padLeft(2, '0')}/"
                          "${_dataSelecionada!.year}",
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Selecione o horário:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selecionarHora,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _horaSelecionada == null
                          ? 'Toque para escolher o horário'
                          : "${_horaSelecionada!.hour.toString().padLeft(2, '0')}:"
                          "${_horaSelecionada!.minute.toString().padLeft(2, '0')}",
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: medico == null
                    ? null
                    : () => _confirmarAgendamento(medico),
                child: const Text(
                  'Confirmar agendamento',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
