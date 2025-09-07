import 'package:flutter/material.dart';
import '../../shared/widgets/organisms/auth_header.dart';
import 'login_form.dart';
import 'registration_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  void toggleForm() => setState(() => showLogin = !showLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: showLogin
                  ? LoginForm(onToggle: toggleForm)
                  : RegistrationForm(onToggle: toggleForm),
            ),
          ],
        ),
      ),
    );
  }
}
