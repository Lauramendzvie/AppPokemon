import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int totalPokedex;
  final int totalFavorites;
  final int totalSelected;

  const ProfileScreen({
    super.key,
    required this.totalPokedex,
    required this.totalFavorites,
    required this.totalSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Cálculo dinâmico de XP baseado nos Pokémons capturados
    final double xpProgress = (totalPokedex / 151).clamp(0.0, 1.0);
    final int currentXp = totalPokedex * 85;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. HEADER DINÂMICO COM POKEBOLA DE FUNDO
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4AD0B0), Color(0xFF33A187)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Ícone de Pokebola estilizado no fundo do Header
                      Positioned(
                        right: -30,
                        top: -20,
                        child: Opacity(
                          opacity: 0.15,
                          child: const Icon(
                            Icons.catching_pokemon,
                            size: 260,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Botão de voltar customizado
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      // Título Interno do Header
                      const Positioned(
                        left: 24,
                        bottom: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Treinador',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Laurita Mendes',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Avatar sobreposto flutuante
                Positioned(
                  bottom: -40,
                  right: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF3D444A),
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 55,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. CONTEÚDO PRINCIPAL (Abaixo do Header)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARD DE NÍVEL E BARRA DE EXPERIÊNCIA
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Nível 42',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            Text(
                              '$currentXp / 12,835 XP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: xpProgress,
                            minHeight: 10,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AD0B0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // CARDS DE STATUS (GRID FLUIDO)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Pokédex', '$totalPokedex', const Color(0xFFFF9F43), Icons.catching_pokemon),
                      _buildStatCard('Favoritos', '$totalFavorites', const Color(0xFFFF5252), Icons.favorite),
                      _buildStatCard('Equipe', '$totalSelected/6', const Color(0xFF54A0FF), Icons.shield),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // SEÇÃO DE CONQUISTAS
                  const Text(
                    'Jornada & Conquistas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAchievementTile(
                    'Primeiros Passos', 
                    'Conectou com sucesso à API e listou os Pokémons.', 
                    true,
                  ),
                  _buildAchievementTile(
                    'Coração de Ouro', 
                    'Demonstrou amor adicionando 5 ou mais favoritos.', 
                    totalFavorites >= 5,
                  ),
                  _buildAchievementTile(
                    'Formação de Elite', 
                    'Completou uma equipe competitiva cheia com 6 Pokémons.', 
                    totalSelected == 6,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.08), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12, 
                color: Colors.grey[500], 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementTile(String title, String desc, bool unlocked) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: unlocked ? 1.0 : 0.55,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unlocked ? Colors.white : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(24),
          border: unlocked ? Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.2), width: 1.5) : null,
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: unlocked ? const Color(0xFFFFF9E6) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                unlocked ? Icons.emoji_events : Icons.lock_outline,
                color: unlocked ? const Color(0xFFFFB300) : Colors.grey[600],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: unlocked ? const Color(0xFF2C3E50) : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12, 
                      color: unlocked ? Colors.grey[600] : Colors.grey[500],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}