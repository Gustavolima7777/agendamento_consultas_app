import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Services
import '../data/services/auth_service.dart';

// Repositories
import '../data/repositories/auth_repository.dart';
import '../data/repositories/medico_repository.dart';
import '../data/repositories/consulta_repository.dart';
import '../data/repositories/usuario_repository.dart';
import '../data/repositories/chat_repository.dart';

// ViewModels
import '../viewmodels/login_view_model.dart';
import '../viewmodels/cadastro_view_model.dart';
import '../viewmodels/medico_view_model.dart';
import '../viewmodels/consulta_view_model.dart';
import '../viewmodels/perfil_view_model.dart';
import '../viewmodels/chat_view_model.dart';

List<SingleChildWidget> buildProviders() {
  return [
    // Services
    Provider(create: (_) => AuthService()),

    // Repositories
    ProxyProvider<AuthService, AuthRepository>(
      update: (_, authService, __) =>
          AuthRepository(authService: authService),
    ),
    Provider(create: (_) => MedicoRepository()),
    Provider(create: (_) => ConsultaRepository()),
    Provider(create: (_) => UsuarioRepository()),
    Provider(create: (_) => ChatRepository()),

    // ViewModels
    ChangeNotifierProvider(
      create: (context) => LoginViewModel(
        authRepository: Provider.of<AuthRepository>(context, listen: false),
        usuarioRepository:
        Provider.of<UsuarioRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => CadastroViewModel(
        authRepository: Provider.of<AuthRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => MedicoViewModel(
        medicoRepository:
        Provider.of<MedicoRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ConsultaViewModel(
        consultaRepository:
        Provider.of<ConsultaRepository>(context, listen: false),
        usuarioRepository:
        Provider.of<UsuarioRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => PerfilViewModel(
        usuarioRepository:
        Provider.of<UsuarioRepository>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        chatRepository: Provider.of<ChatRepository>(context, listen: false),
        usuarioRepository:
        Provider.of<UsuarioRepository>(context, listen: false),
      ),
    ),
  ];
}
