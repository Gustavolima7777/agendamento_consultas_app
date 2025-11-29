import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class CadastroViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  CadastroViewModel({required this.authRepository});

  bool _loading = false;
  String? _erro;

  bool get loading => _loading;
  String? get erro => _erro;

  Future<bool> cadastrar(String nome, String email, String senha) async {
    _loading = true;
    _erro = null;
    notifyListeners();

    // Mock simples — depois trocamos por Firebase / API
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || senha.isEmpty) {
      _erro = "Preencha todos os campos.";
      _loading = false;
      notifyListeners();
      return false;
    }

    _loading = false;
    notifyListeners();
    return true;
  }
}
