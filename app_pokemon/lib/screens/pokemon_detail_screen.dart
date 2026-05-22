import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';
import 'package:app_pokemon/services/api_service.dart';
import 'package:app_pokemon/services/storage_service.dart';
import 'package:app_pokemon/components/pokemon_card.dart';
import 'package:app_pokemon/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Pokemon> _pokemons = [];
  List<String> _favoriteNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final pokemons = await _apiService.fetchPokemons();
      final favorites = await _storageService.getFavorites();

      setState(() {
        _pokemons = pokemons;
        _favoriteNames = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro ao carregar dados: $e');
    }
  }

  void _toggleFavorite(String name) async {
    setState(() {
      if (_favoriteNames.contains(name)) {
        _favoriteNames.remove(name);
      } else {
        _favoriteNames.add(name);
      }
    });
    await _storageService.saveFavorites(_favoriteNames);
  }

  String _getPokemonId(String url) {
    return RegExp(r'\/pokemon\/(\d+)\/').firstMatch(url)?.group(1) ?? '';
  }

  String _getImageUrl(String id) {
    if (id.isNotEmpty) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    }
    return '';
  }

  Color _getPokemonColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('bulbasaur') ||
        n.contains('ivysaur') ||
        n.contains('venusaur') ||
        n.contains('caterpie') ||
        n.contains('metapod') ||
        n.contains('butterfree')) {
      return const Color(0xFF4AD0B0);
    }
    if (n.contains('charmander') ||
        n.contains('charmeleon') ||
        n.contains('charizard')) {
      return const Color(0xFFFB6C6C);
    }
    if (n.contains('squirtle') ||
        n.contains('wartortle') ||
        n.contains('blastoise')) {
      return const Color(0xFF76BDFE);
    }
    if (n.contains('pikachu') || n.contains('raichu')) {
      return const Color(0xFFFFD86F);
    }
    if (n.contains('rattata') ||
        n.contains('raticate') ||
        n.contains('pidgey') ||
        n.contains('pidgeotto') ||
        n.contains('pidgeot')) {
      return const Color(0xFFC3A1E8);
    }
    return const Color(0xFFB0BEC5);
  }

  String _getPokemonSubtype(String name) {
    final n = name.toLowerCase();
    if (n.contains('bulba') || n.contains('ivy') || n.contains('venu')) {
      return 'Grass';
    }
    if (n.contains('char')) return 'Fire';
    if (n.contains('squir') || n.contains('war') || n.contains('blas')) {
      return 'Water';
    }
    if (n.contains('pika')) return 'Electric';
    if (n.contains('cater') || n.contains('meta') || n.contains('butter')) {
      return 'Bug';
    }
    return 'Normal';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openAddPokemonDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastrar Novo Pokémon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Pokémon'),
            ),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Número da Pokedex (ID)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  idController.text.isNotEmpty) {
                try {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  await _apiService.addPokemon(
                    nameController.text,
                    idController.text,
                  );
                  _showSnackBar('Pokémon cadastrado com sucesso!');
                  _loadData();
                } catch (e) {
                  setState(() => _isLoading = false);
                  _showSnackBar('Erro ao salvar: $e');
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600) crossAxisCount = 3;
    if (screenWidth > 900) crossAxisCount = 4;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Pokedex',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    allPokemons: _pokemons,
                    favoriteNames: _favoriteNames,
                    onToggleFavorite: _toggleFavorite,
                    getPokemonId: _getPokemonId,
                    getImageUrl: _getImageUrl,
                    getPokemonColor: _getPokemonColor,
                    getPokemonSubtype: _getPokemonSubtype,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4AD0B0)),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: _pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = _pokemons[index];
                final isFavorite = _favoriteNames.contains(pokemon.name);
                final pokemonId = _getPokemonId(pokemon.url);

                return PokemonCard(
                  pokemon: pokemon,
                  isFavorite: isFavorite,
                  pokemonId: pokemonId,
                  imageUrl: _getImageUrl(pokemonId),
                  cardColor: _getPokemonColor(pokemon.name),
                  typeText: _getPokemonSubtype(pokemon.name),
                  onFavoriteToggle: () => _toggleFavorite(pokemon.name),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPokemonDialog,
        backgroundColor: const Color(0xFF4AD0B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}