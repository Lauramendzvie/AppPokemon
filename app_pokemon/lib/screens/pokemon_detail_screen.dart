import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;
  final String pokemonId;
  final String imageUrl;
  final Color themeColor;
  final String type;
  final bool isSelected;
  final VoidCallback onSelectToggle;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.pokemonId,
    required this.imageUrl,
    required this.themeColor,
    required this.type,
    required this.isSelected,
    required this.onSelectToggle,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pokeAnimationController;
  late Animation<double> _pokeScaleAnimation;
  
  bool _localIsSelected = false;

  // Variáveis mutáveis para suportar a Edição em tempo real
  late String _currentName;
  late String _currentId;
  late String _currentImageUrl;
  late String _currentType;
  late Color _currentThemeColor;
  late int _currentBaseStat;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _localIsSelected = widget.isSelected;

    // Inicializa os estados locais mutáveis
    _currentName = widget.pokemon.name;
    _currentId = widget.pokemonId;
    _currentImageUrl = widget.imageUrl;
    _currentType = widget.type;
    _currentThemeColor = widget.themeColor;
    _currentBaseStat = 40 + (int.tryParse(widget.pokemonId) ?? 5) % 50;

    _pokeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pokeScaleAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pokeAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pokeAnimationController.dispose();
    super.dispose();
  }

  void _triggerPokeAnimation() {
    _pokeAnimationController.forward().then((_) => _pokeAnimationController.reverse());
  }

  // Função que chama o formulário em modo EDICÃO e coleta o resultado
  Future<void> _abrirEditor() async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonFormScreen(
          pokemon: Pokemon(name: _currentName, url: _currentImageUrl),
          pokemonId: _currentId,
          imageUrl: _currentImageUrl,
          type: _currentType,
          themeColor: _currentThemeColor,
        ),
      ),
    );

    if (resultado != null) {
      setState(() {
        _currentName = resultado['name'];
        _currentId = resultado['id'];
        _currentImageUrl = resultado['imageUrl'];
        _currentType = resultado['type'];
        _currentThemeColor = resultado['themeColor'];
        _currentBaseStat = resultado['baseStat'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${_currentId.padLeft(3, '0')}';
    final capitalizedName = _currentName.isEmpty 
        ? '' 
        : _currentName.substring(0, 1).toUpperCase() + _currentName.substring(1);

    final double weight = 5.0 + ((int.tryParse(_currentId) ?? 1) * 3.4) % 90;
    final double height = 0.3 + ((int.tryParse(_currentId) ?? 1) * 0.2) % 2.5;

    return Scaffold(
      backgroundColor: _currentThemeColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // BOTÃO DE EDITAR (NOVO)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 24),
            onPressed: _abrirEditor,
          ),
          // Botão Favoritar / Selecionar Equipe
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                _localIsSelected ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(_localIsSelected),
                color: _localIsSelected ? Colors.redAccent : Colors.white,
                size: 26,
              ),
            ),
            onPressed: () {
              setState(() {
                _localIsSelected = !_localIsSelected;
              });
              widget.onSelectToggle();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: -40,
            child: Opacity(
              opacity: 0.12,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Pok%C3%A9_Ball_icon.svg/1024px-Pok%C3%A9_Ball_icon.svg.png',
                width: 240,
                height: 240,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizedName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 36,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _currentType,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formattedId,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: _currentThemeColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3.5,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        tabs: const [
                          Tab(text: "Sobre"),
                          Tab(text: "Status"),
                          Tab(text: "Movimentos"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildSobreTab(weight, height),
                            _buildStatusTab(_currentBaseStat),
                            _buildMovimentosTab(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _localIsSelected ? Colors.redAccent : _currentThemeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                            ),
                            onPressed: () {
                              setState(() {
                                _localIsSelected = !_localIsSelected;
                              });
                              widget.onSelectToggle();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_localIsSelected ? Icons.remove_circle_outline : Icons.add_circle_outline, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  _localIsSelected ? 'REMOVER DA EQUIPE' : 'ADICIONAR À EQUIPE',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                                ),
                              ],
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
          Positioned(
            top: 85,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _triggerPokeAnimation,
                child: ScaleTransition(
                  scale: _pokeScaleAnimation,
                  child: SizedBox(
                    height: 190,
                    width: 190,
                    child: _currentImageUrl.isNotEmpty
                        ? Hero(
                            tag: 'pokemon-$_currentId',
                            child: Image.network(
                              _currentImageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.catching_pokemon, size: 100, color: Colors.black12),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSobreTab(double weight, double height) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhysicalMetric('${weight.toStringAsFixed(1)} kg', 'PESO', Icons.scale),
              Container(width: 1, height: 40, color: Colors.grey[200]),
              _buildPhysicalMetric(_currentType, 'TIPO', Icons.layers),
              Container(width: 1, height: 40, color: Colors.grey[200]),
              _buildPhysicalMetric('${height.toStringAsFixed(2)} m', 'ALTURA', Icons.straighten),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Biologia alterada e customizada pelo laboratório do treinador. Adaptado ao ecossistema do tipo $_currentType.",
            style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab(int baseStat) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedStatBar('HP', baseStat + 5, _currentThemeColor),
          _buildAnimatedStatBar('Ataque', baseStat + 12, _currentThemeColor),
          _buildAnimatedStatBar('Defesa', baseStat + 8, _currentThemeColor),
          _buildAnimatedStatBar('Velocidade', baseStat - 3, _currentThemeColor),
          _buildAnimatedStatBar('Total', ((baseStat * 4) + 22), _currentThemeColor, max: 500),
        ],
      ),
    );
  }

  Widget _buildMovimentosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ataques Disponíveis:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildMoveChip('⚔️ Investida Correndo'),
              _buildMoveChip('💥 Impacto Customizado'),
              _buildMoveChip('🛡️ Defesa Absoluta'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalMetric(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildAnimatedStatBar(String statName, int value, Color color, {int max = 100}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(statName, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          SizedBox(width: 40, child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value / max),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: animValue, backgroundColor: Colors.grey[100], color: color, minHeight: 8),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveChip(String moveName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(moveName, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

// Simple form screen stub to support editing from the detail screen.
class PokemonFormScreen extends StatefulWidget {
  final Pokemon pokemon;
  final String pokemonId;
  final String imageUrl;
  final String type;
  final Color themeColor;

  const PokemonFormScreen({
    super.key,
    required this.pokemon,
    required this.pokemonId,
    required this.imageUrl,
    required this.type,
    required this.themeColor,
  });

  @override
  State<PokemonFormScreen> createState() => _PokemonFormScreenState();
}

class _PokemonFormScreenState extends State<PokemonFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _imageController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pokemon.name);
    _idController = TextEditingController(text: widget.pokemonId);
    _imageController = TextEditingController(text: widget.imageUrl);
    _typeController = TextEditingController(text: widget.type);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _imageController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'id': _idController.text,
      'imageUrl': _imageController.text,
      'type': _typeController.text,
      'themeColor': widget.themeColor,
      'baseStat': 50,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pokémon'),
        backgroundColor: widget.themeColor,
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _idController, decoration: const InputDecoration(labelText: 'ID')),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'Imagem (URL)')),
            TextField(controller: _typeController, decoration: const InputDecoration(labelText: 'Tipo')),
          ],
        ),
      ),
    );
  }
}