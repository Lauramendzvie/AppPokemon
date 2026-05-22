import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Chave estática para identificar a lista de Pokémons favoritos no dispositivo
  static const String _favoritesKey = 'pokemons_favoritos';

  // 1. Método para buscar a lista de favoritos persistida localmente
  Future<List<String>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retorna a lista salva ou uma lista vazia caso não haja dados ainda
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // 2. Método para gravar/atualizar a lista de favoritos no armazenamento interno
  Future<bool> saveFavorites(List<String> favoriteNames) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Salva a lista de Strings diretamente no cache do dispositivo
    return await prefs.setStringList(_favoritesKey, favoriteNames);
  }
}