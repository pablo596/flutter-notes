import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/services/services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool activeEditing = false;
  bool showPassword = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _edadController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    _nameController.text = authService.usuario.nombre!;
    _emailController.text =
        authService.usuario.correo != null ? authService.usuario.correo! : '';

    _edadController.text =
        '${DateTime.now().difference(DateTime.parse(authService.usuario.date!)).inDays ~/ 365} años';
    _passController.text = authService.usuario.password != null
        ? authService.usuario.password!
        : '';
    // _passController.text = '';
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0xFFd9d9d9),
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 180,
                  ),
                ),
                Container(
                  child: Column(children: [
                    TextField(
                      controller: _nameController,
                      readOnly: !activeEditing,
                      decoration: InputDecoration(
                          label: Container(
                        child: const Text(
                          'Nombre',
                        ),
                      )),
                    ),
                    TextField(
                      controller: _emailController,
                      readOnly: !activeEditing,
                      decoration: InputDecoration(label: Text('Correo')),
                    ),
                    TextField(
                      controller: _edadController,
                      readOnly: !activeEditing,
                      decoration: InputDecoration(label: Text('Edad')),
                    ),
                    TextField(
                      controller: _passController,
                      readOnly: !activeEditing,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        label: Text('Contraseña'),
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
                  ]),
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     minimumSize: const MaterialStatePropertyAll<Size>(
                //         Size.fromHeight(50)),
                //     backgroundColor:
                //         const MaterialStatePropertyAll<Color>(Colors.black),
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //       const RoundedRectangleBorder(),
                //     ),
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       activeEditing = true;
                //     });
                //   },
                //   child: Text(
                //     !activeEditing ? 'Editar' : 'Guardar',
                //     style: const TextStyle(fontSize: 24, color: Colors.white),
                //   ),
                // ),
                const SizedBox(height: 10),
                activeEditing
                    ? ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: const MaterialStatePropertyAll<Size>(
                              Size.fromHeight(50)),
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.redAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            activeEditing = false;
                          });
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
