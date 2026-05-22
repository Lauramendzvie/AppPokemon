const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

//  20 fucking pokemons aaaaaaaaAAAAAAAAAA
let meusPokemons = [
    { name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/" },
    { name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/" },
    { name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/" },
    { name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/" },
    { name: "charmeleon", url: "https://pokeapi.co/api/v2/pokemon/5/" },
    { name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/" },
    { name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/" },
    { name: "wartortle", url: "https://pokeapi.co/api/v2/pokemon/8/" },
    { name: "blastoise", url: "https://pokeapi.co/api/v2/pokemon/9/" },
    { name: "caterpie", url: "https://pokeapi.co/api/v2/pokemon/10/" },
    { name: "metapod", url: "https://pokeapi.co/api/v2/pokemon/11/" },
    { name: "butterfree", url: "https://pokeapi.co/api/v2/pokemon/12/" },
    { name: "weedle", url: "https://pokeapi.co/api/v2/pokemon/13/" },
    { name: "kakuna", url: "https://pokeapi.co/api/v2/pokemon/14/" },
    { name: "beedrill", url: "https://pokeapi.co/api/v2/pokemon/15/" },
    { name: "pidgey", url: "https://pokeapi.co/api/v2/pokemon/16/" },
    { name: "pidgeotto", url: "https://pokeapi.co/api/v2/pokemon/17/" },
    { name: "pidgeot", url: "https://pokeapi.co/api/v2/pokemon/18/" },
    { name: "rattata", url: "https://pokeapi.co/api/v2/pokemon/19/" },
    { name: "raticate", url: "https://pokeapi.co/api/v2/pokemon/20/" }
];

// 1. ROTA GET - Listar todos os Pokémons (Cumpre o critério GET da SA2)
app.get('/api/pokemon', (req, res) => {
    res.json({ results: meusPokemons });
});

// 2. ROTA POST - Adicionar um novo Pokémon (Cumpre o critério POST da SA2)
app.post('/api/pokemon', (req, res) => {
    const { name, url } = req.body;
    if (!name || !url) {
        return res.status(400).json({ error: "Nome e URL são obrigatórios" });
    }
    const novoPokemon = { name: name.toLowerCase(), url };
    meusPokemons.push(novoPokemon);
    res.status(201).json(novoPokemon);
});

// 3. ROTA PUT - Atualizar dados de um Pokémon (Cumpre o critério PUT da SA2)
app.put('/api/pokemon/:name', (req, res) => {
    const { name } = req.params;
    const { url } = req.body;
    const pokemon = meusPokemons.find(p => p.name.toLowerCase() === name.toLowerCase());
    
    if (!pokemon) {
        return res.status(404).json({ error: "Pokémon não encontrado" });
    }
    
    if (url) pokemon.url = url;
    res.json(pokemon);
});

// 4. ROTA DELETE - Eliminar um Pokémon (Cumpre o critério DELETE da SA2)
app.delete('/api/pokemon/:name', (req, res) => {
    const { name } = req.params;
    const index = meusPokemons.findIndex(p => p.name.toLowerCase() === name.toLowerCase());
    
    if (index === -1) {
        return res.status(404).json({ error: "Pokémon não encontrado" });
    }
    
    const deletado = meusPokemons.splice(index, 1);
    res.json({ message: `Pokémon ${deletado[0].name} removido com sucesso!` });
});

app.listen(PORT, () => {
    console.log(`Servidor backend a rodar com sucesso em http://localhost:${PORT}`);
});