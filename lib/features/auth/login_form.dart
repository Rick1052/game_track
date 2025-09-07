import 'package:flutter/material.dart';
import '../../../../shared/utils/db_helper.dart';
import '../../../../shared/widgets/atoms/custom_button.dart';
import '../../../../shared/widgets/atoms/loading_indicator.dart';
import '../../shared/widgets/molecules/input_with_label.dart';
import '../products/presentation/pages/home_app.dart'; // Importe sua tela principal

class LoginForm extends StatefulWidget {
  final VoidCallback onToggle;

  const LoginForm({super.key, required this.onToggle});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  final dbHelper = DBHelper.instance; // Instância do SQLite

  Future<void> _handleLogin() async {
    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final user = await dbHelper.getUser(email, password);

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeApp(
              isDarkMode: false, // ou pegar de algum estado
              onThemeChanged: (value) {
                // Aqui você pode atualizar algum estado global se quiser
              },
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Email ou senha inválidos';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao logar: $e';
      });
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputWithLabel(label: 'Email', controller: _emailController),
        const SizedBox(height: 16),
        InputWithLabel(
          label: 'Senha',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _loading
            ? const LoadingIndicator(size: 40)
            : CustomButton(label: 'Login', onPressed: _handleLogin),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.onToggle,
          child: const Text('Não tem conta? Cadastre-se'),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
