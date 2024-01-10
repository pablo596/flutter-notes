import 'package:flutter/material.dart';
import 'package:notes/screens/screens.dart';

final appRoutes = <String, WidgetBuilder>{
  "login": (_) => const LoginScreen(),
  "loading": (_) => const LoadingScreen(),
  "register": (_) => const RegisterScreen(),
  "home": (_) => const HomeScreen(),
  "note": (_) => const NoteViewScreen(),
  "profile": (_) => const ProfileScreen()
};
