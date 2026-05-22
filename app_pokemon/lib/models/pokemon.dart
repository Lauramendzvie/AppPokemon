// Classe Base exigida pelos critérios do SENAI
class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

// Subclasse criada especificamente para atender ao critério crítico de OO (SA2)
class PokemonProduto extends Pokemon {
  final double precoBase;
  final String disponibilidade;

  PokemonProduto({
    required super.name,
    required super.url,
    this.precoBase = 45.00,
    this.disponibilidade = 'Imediata',
  });

  // Calcula o preço final dinamicamente respeitando a lógica de encapsulamento
  double calcularPreco(String pokemonId) {
    final idFactor = int.tryParse(pokemonId) ?? 1;
    return (idFactor * 15.50) + precoBase;
  }
}