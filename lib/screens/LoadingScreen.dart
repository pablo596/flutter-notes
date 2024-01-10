import 'package:flutter/material.dart';
import 'package:notes/screens/screens.dart';
import 'package:notes/services/services.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      final autenticado = await authService.isLoggedIn();

      if (autenticado) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomeScreen(),
            transitionDuration: Duration(milliseconds: 0),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: Duration(milliseconds: 0),
          ),
        );
      }
    } catch (e) {
      print('error $e');
    }
  }
}
