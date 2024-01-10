import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/helpers/helpers.dart';
import 'package:notes/services/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime currentDate = DateTime.now();
  DateTime todayDate = DateTime.now();
  bool showPassword = false;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        locale: const Locale("es", "ES"),
        initialDate: currentDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(1930),
        lastDate: todayDate);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        _dateController.text = currentDate.toString().split(" ")[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
          ),
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
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('Nombre'),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFFd9d9d9)),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: _dateController,
                      readOnly: true,
                      canRequestFocus: false,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: const InputDecoration(
                        label: Text('Fecha de Nacimiento'),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
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
                      minimumSize: const MaterialStatePropertyAll<Size>(
                          Size.fromHeight(50)),
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
                            final registerOk = await authService.register(
                                _nameController.text,
                                _emailController.text.trim(),
                                _passController.text.trim(),
                                currentDate);
                            if (registerOk == true) {
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              // Mostrar alerta
                              mostrarAlerta(context, 'Registro incorrecto',
                                  '$registerOk');
                            }
                          },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        text: '¿Ya posees una cuenta?',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Ingresa',
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, 'login');
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
