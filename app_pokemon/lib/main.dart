import 'package:flutter/material.dart';
import 'package:app_pokemon/screens/login_screen.dart'; // Importe a tela de Login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Alterado aqui para começar no Login
    );
  }
}