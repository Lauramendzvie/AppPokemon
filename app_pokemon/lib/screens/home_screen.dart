import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';
import 'package:app_pokemon/services/api_service.dart';
import 'package:app_pokemon/services/storage_service.dart';
import 'package:app_pokemon/components/pokemon_card.dart';
import 'package:app_pokemon/screens/favorites_screen.dart';
import 'package:app_pokemon/screens/selected_screen.dart';
import 'package:app_pokemon/screens/profile_screen.dart';
// Importação da tela de formulário que melhoramos
import 'package:app_pokemon/screens/pokemon_form_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final PageController _pageController = PageController(viewportFraction: 0.85);

  List<Pokemon> _pokemons = [];
  List<String> _favoriteNames = [];
  List<String> _selectedNames = [];
  bool _isLoading = true;
  int _carouselIndex = 0;
  Timer? _carouselTimer;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'name': 'Charizard',
      'image': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png',
      'color': const Color(0xFFFB6C6C),
      'tag': 'Mega Fire'
    },
    {
      'name': 'Mewtwo',
      'image': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png',
      'color': const Color(0xFFC3A1E8),
      'tag': 'Legendary'
    },
    {
      'name': 'Gyarados',
      'image': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/130.png',
      'color': const Color(0xFF76BDFE),
      'tag': 'Atk Boss'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _startCarouselAutoPlay();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarouselAutoPlay() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _carouselIndex + 1;
        if (nextPage >= _carouselItems.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
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

  void _toggleSelect(String name) {
    setState(() {
      if (_selectedNames.contains(name)) {
        _selectedNames.remove(name);
      } else {
        _selectedNames.add(name);
      }
    });
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

  // Abre a tela premium para CRIAR um novo Pokémon
  Future<void> _navigateToCreatePokemon() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const PokemonFormScreen(),
      ),
    );

    if (result != null) {
      try {
        setState(() => _isLoading = true);
        await _apiService.addPokemon(
          result['name'],
          result['id'],
        );
        _showSnackBar('${result['name']} cadastrado com sucesso!');
        _loadData();
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar('Erro ao salvar Pokémon: $e');
      }
    }
  }

  // Abre a tela premium para EDITAR um Pokémon existente (Chamado no clique longo do card)
  Future<void> _navigateToEditPokemon(Pokemon pokemon) async {
    final pokemonId = _getPokemonId(pokemon.url);
    final currentType = _getPokemonSubtype(pokemon.name);
    final currentColor = _getPokemonColor(pokemon.name);

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonFormScreen(
          pokemon: pokemon,
          pokemonId: pokemonId,
          imageUrl: _getImageUrl(pokemonId),
          type: currentType,
          themeColor: currentColor,
        ),
      ),
    );

    if (result != null) {
      // Aqui você conecta com a lógica/função de atualizar da sua API se houver
      _showSnackBar('${result['name']} atualizado localmente!');
      _loadData(); 
    }
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
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedScreen(
                    allPokemons: _pokemons,
                    selectedNames: _selectedNames,
                    onToggleSelect: _toggleSelect,
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
            child: const Text(
              'Equipe',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    allPokemons: _pokemons,
                    favoriteNames: _favoriteNames,
                    onToggleFavorite: _toggleFavorite,
                    selectedNames: _selectedNames,
                    onToggleSelect: _toggleSelect,
                    getPokemonId: _getPokemonId,
                    getImageUrl: _getImageUrl,
                    getPokemonColor: _getPokemonColor,
                    getPokemonSubtype: _getPokemonSubtype,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
            child: const Text(
              'Favoritos',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    totalPokedex: _pokemons.length,
                    totalFavorites: _favoriteNames.length,
                    totalSelected: _selectedNames.length,
                  ),
                ),
              );
            },
            child: const Text(
              'Perfil',
              style: TextStyle(
                color: Color(0xFF4AD0B0),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.refresh, color: Colors.black87, size: 20),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadData();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4AD0B0)),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Qual Pokémon você escolhe?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Explore o mundo Pokémon e monte sua equipe ideal',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _carouselItems.length,
                      onPageChanged: (index) {
                        setState(() => _carouselIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final item = _carouselItems[index];
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page! - index;
                              value = (1 - (value.abs() * 0.08)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: Curves.easeOut.transform(value) * 160,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: item['color'],
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: item['color'].withValues(alpha: 0.35),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -20,
                                  bottom: -20,
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: const Icon(
                                      Icons.catching_pokemon,
                                      size: 160,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item['tag'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 8,
                                  top: 8,
                                  child: Image.network(
                                    item['image'],
                                    fit: BoxFit.contain,
                                    width: 130,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _carouselItems.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(top: 14, bottom: 28, left: 4, right: 4),
                        width: _carouselIndex == index ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _carouselIndex == index
                              ? const Color(0xFF4AD0B0)
                              : Colors.grey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pokemon = _pokemons[index];
                        final isFavorite = _favoriteNames.contains(pokemon.name);
                        final isSelected = _selectedNames.contains(pokemon.name);
                        final pokemonId = _getPokemonId(pokemon.url);

                        // Envolvendo o Card em um GestureDetector para habilitar clique longo (Editar)
                        return GestureDetector(
                          onLongPress: () => _navigateToEditPokemon(pokemon),
                          child: PokemonCard(
                            pokemon: pokemon,
                            isFavorite: isFavorite,
                            pokemonId: pokemonId,
                            imageUrl: _getImageUrl(pokemonId),
                            cardColor: _getPokemonColor(pokemon.name),
                            typeText: _getPokemonSubtype(pokemon.name),
                            onFavoriteToggle: () => _toggleFavorite(pokemon.name),
                            isSelected: isSelected,
                            onSelectToggle: () {
                              _toggleSelect(pokemon.name);
                              if (!isSelected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectedScreen(
                                      allPokemons: _pokemons,
                                      selectedNames: _selectedNames,
                                      onToggleSelect: _toggleSelect,
                                      favoriteNames: _favoriteNames,
                                      onToggleFavorite: _toggleFavorite,
                                      getPokemonId: _getPokemonId,
                                      getImageUrl: _getImageUrl,
                                      getPokemonColor: _getPokemonColor,
                                      getPokemonSubtype: _getPokemonSubtype,
                                    ),
                                  ),
                                ).then((_) => setState(() {}));
                              }
                            },
                          ),
                        );
                      },
                      childCount: _pokemons.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        // Agora chama a função de navegação para a nova tela estilizada
        onPressed: _navigateToCreatePokemon,
        backgroundColor: const Color(0xFF4AD0B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}