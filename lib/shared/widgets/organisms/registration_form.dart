import 'package:flutter/material.dart';
import '../atoms/custom_button.dart';
import '../molecules/input_with_label.dart';

class RegistrationForm extends StatefulWidget {
  final Future<void> Function(String email, String password) onSubmit;

  const RegistrationForm({super.key, required this.onSubmit});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await widget.onSubmit(_emailController.text, _passwordController.text);

    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputWithLabel(
            label: "Email",
            controller: _emailController,
            validator: (v) {
              if (v == null || !v.contains('@')) return "Email inválido";
              return null;
            },
          ),
          const SizedBox(height: 16),
          InputWithLabel(
            label: "Senha",
            controller: _passwordController,
            obscureText: true,
            validator: (v) {
              if (v == null || v.length < 6) return "Senha muito curta";
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            label: "Cadastrar",
            onPressed: _handleSubmit, // <-- usar onPressed
            loading: _loading,
          ),
        ],
      ),
    );
  }
}
