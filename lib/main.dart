import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/routes/appRoutes.dart';
import 'package:notes/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => NotasService()),
      ],
      child: MaterialApp(
        title: 'Notas',
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
        debugShowCheckedModeBanner: false,
        initialRoute: "loading",
        routes: appRoutes,
      ),
    );
  }
}
