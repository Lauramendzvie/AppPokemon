import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';
import 'package:app_pokemon/components/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Pokemon> allPokemons;
  final List<String> favoriteNames;
  final Function(String) onToggleFavorite;
  final String Function(String) getPokemonId;
  final String Function(String) getImageUrl;
  final Color Function(String) getPokemonColor;
  final String Function(String) getPokemonSubtype;

  const FavoritesScreen({
    super.key,
    required this.allPokemons,
    required this.favoriteNames,
    required this.onToggleFavorite,
    required this.getPokemonId,
    required this.getImageUrl,
    required this.getPokemonColor,
    required this.getPokemonSubtype,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritedList = widget.allPokemons
        .where((p) => widget.favoriteNames.contains(p.name))
        .toList();

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600) crossAxisCount = 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Meus Favoritos',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoritedList.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item favoritado localmente.',
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: favoritedList.length,
              itemBuilder: (context, index) {
                final pokemon = favoritedList[index];
                final pokemonId = widget.getPokemonId(pokemon.url);

                return PokemonCard(
                  pokemon: pokemon,
                  isFavorite: true,
                  pokemonId: pokemonId,
                  imageUrl: widget.getImageUrl(pokemonId),
                  cardColor: widget.getPokemonColor(pokemon.name),
                  typeText: widget.getPokemonSubtype(pokemon.name),
                  onFavoriteToggle: () {
                    setState(() {
                      widget.onToggleFavorite(pokemon.name);
                    });
                  },
                );
              },
            ),
    );
  }
}