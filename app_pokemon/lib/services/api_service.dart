import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_pokemon/models/pokemon.dart'; 

class ApiService {
  static const String apiUrl = 'http://localhost:3000/api/pokemon'; 

  // GET - Listar
  Future<List<Pokemon>> fetchPokemons() async { 
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body); 
      final List<dynamic> pokemonsJson = data['results'];
      return pokemonsJson.map((json) => Pokemon.fromJson(json)).toList(); 
    } else {
      throw Exception('Falha ao carregar os pokemons da API');
    }
  }

  // >>> GARANTE QUE ESTE MÉTODO ABAIXO EXISTE DENTRO DA CLASSE <<<
  Future<void> addPokemon(String name, String idImage) async {
    final String fakeUrl = 'https://pokeapi.co/api/v2/pokemon/$idImage/';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'url': fakeUrl,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar o Pokémon no servidor.');
    }
  }
}