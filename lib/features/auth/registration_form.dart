import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../../../shared/utils/db_helper.dart';
// import '../../../../shared/widgets/atoms/custom_input_field.dart';
import '../../../../shared/widgets/atoms/custom_button.dart';
import '../../../../shared/widgets/atoms/loading_indicator.dart';
import '../../shared/widgets/molecules/input_with_label.dart';

class RegistrationForm extends StatefulWidget {
  final VoidCallback onToggle;

  const RegistrationForm({super.key, required this.onToggle});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final db = DBHelper.instance;

    // Verifica se já existe
    final existingUser = await db.getUserByEmail(_emailController.text.trim());
    if (existingUser != null) {
      setState(() {
        _errorMessage = 'Email já cadastrado';
        _loading = false;
      });
      return;
    }

    final user = UserModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await db.insertUser(user);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _loading = false;
      _successMessage = 'Cadastro realizado com sucesso!';
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputWithLabel(label: 'Nome', controller: _nameController),
        const SizedBox(height: 16),
        InputWithLabel(label: 'Email', controller: _emailController),
        const SizedBox(height: 16),
        InputWithLabel(
            label: 'Senha',
            controller: _passwordController,
            obscureText: true),
        const SizedBox(height: 24),
        _loading
            ? const LoadingIndicator(size: 40)
            : CustomButton(label: 'Cadastrar', onPressed: _register),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.onToggle,
          child: const Text('Já tem conta? Faça login'),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (_successMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }
}
