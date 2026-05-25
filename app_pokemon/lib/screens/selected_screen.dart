import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';
import 'package:app_pokemon/components/pokemon_card.dart';

class SelectedScreen extends StatefulWidget {
  final List<Pokemon> allPokemons;
  final List<String> selectedNames;
  final Function(String) onToggleSelect;
  final List<String> favoriteNames;
  final Function(String) onToggleFavorite;
  final String Function(String) getPokemonId;
  final String Function(String) getImageUrl;
  final Color Function(String) getPokemonColor;
  final String Function(String) getPokemonSubtype;

  const SelectedScreen({
    super.key,
    required this.allPokemons,
    required this.selectedNames,
    required this.onToggleSelect,
    required this.favoriteNames,
    required this.onToggleFavorite,
    required this.getPokemonId,
    required this.getImageUrl,
    required this.getPokemonColor,
    required this.getPokemonSubtype,
  });

  @override
  State<SelectedScreen> createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<SelectedScreen> {
  @override
  Widget build(BuildContext context) {
    final displayPokemons = widget.allPokemons
        .where((pokemon) => widget.selectedNames.contains(pokemon.name))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Meus Selecionados',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: displayPokemons.isEmpty
          ? const Center(
              child: Text(
                'Nenhum Pokémon selecionado.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: displayPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = displayPokemons[index];
                final isFavorite = widget.favoriteNames.contains(pokemon.name);
                final isSelected = widget.selectedNames.contains(pokemon.name);
                final pokemonId = widget.getPokemonId(pokemon.url);

                return PokemonCard(
                  pokemon: pokemon,
                  isFavorite: isFavorite,
                  pokemonId: pokemonId,
                  imageUrl: widget.getImageUrl(pokemonId),
                  cardColor: widget.getPokemonColor(pokemon.name),
                  typeText: widget.getPokemonSubtype(pokemon.name),
                  onFavoriteToggle: () {
                    setState(() {
                      widget.onToggleFavorite(pokemon.name);
                    });
                  },
                  isSelected: isSelected,
                  onSelectToggle: () {
                    setState(() {
                      widget.onToggleSelect(pokemon.name);
                    });
                  },
                );
              },
            ),
    );
  }
}