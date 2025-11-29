import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

class MedicoListaView extends StatefulWidget {
  const MedicoListaView({super.key});

  @override
  State<MedicoListaView> createState() => _MedicoListaViewState();
}

class _MedicoListaViewState extends State<MedicoListaView> {
  final TextEditingController _buscaController = TextEditingController();
  String _filtroEspecialidade = 'Cardiologia';

  final List<Map<String, dynamic>> _medicos = const [
    {
      "nome": "Dr. Lucas Andrade",
      "especialidade": "Cardiologista",
      "avaliacao": 4.8,
      "local": "Av. Paulista, 123 - São Paulo",
    },
    {
      "nome": "Dra. Sofia Oliveira",
      "especialidade": "Psicóloga",
      "avaliacao": 4.9,
      "local": "Atendimento Online",
    },
    {
      "nome": "Dr. Fernando Costa",
      "especialidade": "Clínico Geral",
      "avaliacao": 4.7,
      "local": "R. da Consolação, 555 - São Paulo",
    },
  ];

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final medicosFiltrados = _medicos.where((medico) {
      final query = _buscaController.text.toLowerCase();
      final nome = (medico['nome'] as String).toLowerCase();
      final esp = (medico['especialidade'] as String).toLowerCase();

      final combinaBusca =
          query.isEmpty || nome.contains(query) || esp.contains(query);

      final combinaEspecialidade = _filtroEspecialidade == 'Todos'
          ? true
          : medico['especialidade']
          .toString()
          .toLowerCase()
          .contains(_filtroEspecialidade.toLowerCase());

      return combinaBusca && combinaEspecialidade;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF020818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020818),
        elevation: 0,
        title: const Text('Encontrar um Profissional'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // futuro: abrir menu / drawer
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // futuro: filtros avançados
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // campo de busca
            TextField(
              controller: _buscaController,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou especialidade...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF071427),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            // chips de especialidade
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFiltroChip('Cardiologia'),
                  _buildFiltroChip('Clínico Geral'),
                  _buildFiltroChip('Psicologia'),
                  _buildFiltroChip('Todos'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Recomendados para você',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: medicosFiltrados.length,
                itemBuilder: (context, index) {
                  final medico = medicosFiltrados[index];

                  return _MedicoCard(
                    medico: medico,
                    onVerAgenda: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.medicoDetalhes,
                        arguments: medico,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltroChip(String label) {
    final bool selecionado = _filtroEspecialidade == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selecionado ? Colors.white : Colors.white70,
            fontSize: 13,
          ),
        ),
        selected: selecionado,
        selectedColor: const Color(0xFF1E88E5),
        backgroundColor: const Color(0xFF071427),
        onSelected: (_) {
          setState(() {
            _filtroEspecialidade = label;
          });
        },
      ),
    );
  }
}

class _MedicoCard extends StatelessWidget {
  final Map<String, dynamic> medico;
  final VoidCallback onVerAgenda;

  const _MedicoCard({
    required this.medico,
    required this.onVerAgenda,
  });

  @override
  Widget build(BuildContext context) {
    final nome = medico['nome'] as String;
    final especialidade = medico['especialidade'] as String;
    final avaliacao = medico['avaliacao'] as double;
    final local = medico['local'] as String;

    final iniciais = _gerarIniciais(nome);

    return Card(
      color: const Color(0xFF071427),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF1E88E5),
              child: Text(
                iniciais,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    especialidade,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFFFFD54F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        avaliacao.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    local,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1E88E5)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: onVerAgenda,
                        child: const Text(
                          'Ver agenda',
                          style: TextStyle(
                            color: Color(0xFF1E88E5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _gerarIniciais(String nome) {
    final partes = nome.split(' ');
    if (partes.length >= 2) {
      return (partes[0][0] + partes[1][0]).toUpperCase();
    }
    return nome.substring(0, 1).toUpperCase();
  }
}
