import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/helpers/helpers.dart';
import 'package:notes/services/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.book, size: 170),
              const Text(
                'Notas',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFd9d9d9)),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('Correo'),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFd9d9d9)),
                child: TextField(
                  obscureText: !showPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passController,
                  decoration: InputDecoration(
                    label: const Text('Contraseña'),
                    contentPadding: const EdgeInsets.all(10),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize:
                      const MaterialStatePropertyAll<Size>(Size.fromHeight(50)),
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(),
                  ),
                ),
                onPressed: authService.autenticando
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final loginOK = await authService.login(
                            _emailController.text.trim(),
                            _passController.text.trim());
                        if (loginOK) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          // Mostrar alerta
                          mostrarAlerta(context, 'Login incorrecto',
                              'Revise sus credenciales de acceso');
                        }
                      },
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    text: '¿No tienes cuenta?',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Registrate',
                        style: const TextStyle(
                            color: Colors.blueAccent, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to desired screen

                            Navigator.pushReplacementNamed(context, 'register');
                          },
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
