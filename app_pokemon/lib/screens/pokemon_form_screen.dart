import 'package:flutter/material.dart';
import 'package:app_pokemon/models/pokemon.dart';

class PokemonFormScreen extends StatefulWidget {
  final Pokemon? pokemon;
  final String? pokemonId;
  final String? imageUrl;
  final String? type;
  final Color? themeColor;

  const PokemonFormScreen({
    super.key,
    this.pokemon,
    this.pokemonId,
    this.imageUrl,
    this.type,
    this.themeColor,
  });

  @override
  State<PokemonFormScreen> createState() => _PokemonFormScreenState();
}

class _PokemonFormScreenState extends State<PokemonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _imageController;
  
  String _selectedType = 'Normal';
  Color _selectedColor = Colors.blueGrey;
  int _baseStat = 50;

  final List<String> _types = [
    'Normal', 'Fire', 'Water', 'Grass', 'Electric', 
    'Ice', 'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic'
  ];

  final Map<String, Color> _typeColors = {
    'Normal': Colors.blueGrey,
    'Fire': Colors.orangeAccent,
    'Water': Colors.blueAccent,
    'Grass': const Color(0xFF4AD0B0),
    'Electric': Colors.amber,
    'Ice': Colors.cyan,
    'Fighting': Colors.redAccent,
    'Poison': Colors.purpleAccent,
    'Ground': Colors.brown,
    'Flying': Colors.indigoAccent,
    'Psychic': Colors.pinkAccent,
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pokemon?.name ?? '');
    _idController = TextEditingController(text: widget.pokemonId ?? '');
    _imageController = TextEditingController(text: widget.imageUrl ?? '');
    _selectedType = widget.type ?? 'Normal';
    _selectedColor = widget.themeColor ?? _typeColors[_selectedType] ?? Colors.blueGrey;
    
    if (widget.pokemonId != null) {
      _baseStat = 40 + (int.tryParse(widget.pokemonId!) ?? 5) % 50;
    }

    // Ouvintes para atualizar o Preview Card em tempo real enquanto digita
    _nameController.addListener(() => setState(() {}));
    _imageController.addListener(() => setState(() {}));
    _idController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pokemon != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Dados' : 'Novo Pokémon',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: _selectedColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CARD DE PREVIEW EM TEMPO REAL
              _buildLivePreviewCard(),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo: Nome
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _buildInputDecoration('Nome do Pokémon', Icons.badge),
                      validator: (value) => value == null || value.isEmpty ? 'Insira um nome válido' : null,
                    ),
                    const SizedBox(height: 20),

                    // Campo: ID Número
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('Número Identificador (Ex: 025)', Icons.tag),
                      validator: (value) => value == null || value.isEmpty ? 'Insira o número' : null,
                    ),
                    const SizedBox(height: 20),

                    // Campo: URL da Imagem
                    TextFormField(
                      controller: _imageController,
                      keyboardType: TextInputType.url,
                      decoration: _buildInputDecoration('URL da Imagem (.png)', Icons.link),
                    ),
                    const SizedBox(height: 28),

                    // 2. SELETOR VISUAL DE TIPOS EM CHIPS
                    const Text(
                      'Selecione o Tipo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _types.length,
                        itemBuilder: (context, index) {
                          final type = _types[index];
                          final isSelected = _selectedType == type;
                          final typeColor = _typeColors[type] ?? Colors.grey;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: typeColor,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                              ),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedType = type;
                                    _selectedColor = typeColor;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 3. SLIDER DE STATUS CUSTOMIZADO
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Força Base', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('$_baseStat pts', style: TextStyle(fontWeight: FontWeight.w900, color: _selectedColor, fontSize: 16)),
                            ],
                          ),
                          Slider(
                            value: _baseStat.toDouble(),
                            min: 10,
                            max: 150,
                            divisions: 140,
                            activeColor: _selectedColor,
                            inactiveColor: Colors.grey[200],
                            onChanged: (double newValue) {
                              setState(() {
                                _baseStat = newValue.round();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // BOTÃO DE SALVAR
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 3,
                          shadowColor: _selectedColor.withValues(alpha: 0.4),
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          isEditing ? 'SALVAR ALTERAÇÕES' : 'CRIAR POKÉMON',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget do Card de Visualização Dinâmica Superior
  Widget _buildLivePreviewCard() {
    final displayName = _nameController.text.trim().isEmpty ? 'Nome do Pokémon' : _nameController.text.trim();
    final displayId = _idController.text.trim().isEmpty ? '000' : _idController.text.trim().padLeft(3, '0');
    final displayImage = _imageController.text.trim();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      decoration: BoxDecoration(
        color: _selectedColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$displayId',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w900, fontSize: 18),
                ),
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    _selectedType.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: displayImage.isNotEmpty
                  ? Image.network(
                      displayImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.catching_pokemon, size: 50, color: Colors.white70),
                    )
                  : const Icon(Icons.catching_pokemon, size: 50, color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }

  // Construtor auxiliar de estilização dos campos de texto input
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: _selectedColor),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _selectedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String finalUrl = _imageController.text.trim();
      if (finalUrl.isEmpty) {
        finalUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Pok%C3%A9_Ball_icon.svg/1024px-Pok%C3%A9_Ball_icon.svg.png';
      }

      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'id': _idController.text.trim(),
        'imageUrl': finalUrl,
        'type': _selectedType,
        'themeColor': _selectedColor,
        'baseStat': _baseStat,
      });
    }
  }
}