import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'core/di.dart';

// Telas paciente
import 'ui/login/login_view.dart';
import 'ui/cadastro/cadastro_view.dart';
import 'ui/home/home_view.dart';
import 'ui/medico/medico_lista_view.dart';
import 'ui/medico/medico_detalhes_view.dart';
import 'ui/agenda/agenda_view.dart';
import 'ui/consultas/consultas_view.dart';
import 'ui/chat/chat_view.dart';
import 'ui/perfil/perfil_view.dart';

// Tela admin
import 'ui/admin/admin_home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginView(),
          AppRoutes.cadastro: (_) => const CadastroView(),
          AppRoutes.home: (_) => const HomeView(),
          AppRoutes.medicoLista: (_) => const MedicoListaView(),
          AppRoutes.medicoDetalhes: (_) => const MedicoDetalhesView(),
          AppRoutes.agenda: (_) => const AgendaView(),
          AppRoutes.consultas: (_) => const ConsultasView(),
          AppRoutes.chat: (_) => const ChatView(),
          AppRoutes.perfil: (_) => const PerfilView(),

          AppRoutes.adminHome: (_) => const AdminHomeView(),
        },
      ),
    );
  }
}
