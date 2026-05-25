import 'package:flutter/material.dart';
import 'package:app_pokemon/screens/home_screen.dart';
import 'package:app_pokemon/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.05,
              child: const Icon(
                Icons.catching_pokemon,
                size: 240,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 160,
                      width: 160,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD86F).withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Faça login para gerenciar sua Pokédex',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4AD0B0)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4AD0B0)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF4AD0B0).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4AD0B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Não tem uma conta? Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF4AD0B0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}