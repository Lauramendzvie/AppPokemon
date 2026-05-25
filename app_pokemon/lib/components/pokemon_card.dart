import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';
import 'package:app_pokemon/screens/pokemon_detail_screen.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final String pokemonId;
  final String imageUrl;
  final Color cardColor;
  final String typeText;
  final VoidCallback onFavoriteToggle;
  final bool isSelected;
  final VoidCallback onSelectToggle;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.pokemonId,
    required this.imageUrl,
    required this.cardColor,
    required this.typeText,
    required this.onFavoriteToggle,
    required this.isSelected,
    required this.onSelectToggle,
  });

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${pokemonId.padLeft(3, '0')}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(
              pokemon: pokemon,
              pokemonId: pokemonId,
              imageUrl: imageUrl,
              themeColor: cardColor,
              type: typeText,
              isSelected: isSelected,
              onSelectToggle: onSelectToggle,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: cardColor,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                right: 12,
                child: Text(
                  formattedId,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.12),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.substring(0, 1).toUpperCase() +
                          pokemon.name.substring(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        typeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error,
                            color: Colors.white54,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Positioned(
                bottom: -2,
                left: -2,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.white : Colors.white60,
                    size: 18,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}