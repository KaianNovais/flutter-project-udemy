import 'dart:convert';

import 'package:api_consumo_flutter_movies/model/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService with ChangeNotifier {
  //informamos o link da nossa api
  final String url = "http://localhost:3000/api/filmes";

  //famos o método para listar os filmes
  Future<List<Filme>> listarFilmes() async {
    //criamos uma variável que recebe os dados da nossa api
    final response = await http.get(Uri.parse(url));

    //verificamos se a api retorno o status 200
    if (response.statusCode == 200) {
      //pegamos os dados do corpo da api
      List<dynamic> body = jsonDecode(response.body);
      //convertemos esses dados em uma classe que definimos (filme)
      List<Filme> filmes = body.map((item) => Filme.fromJson(item)).toList();
      //retornamos os dados
      debugPrint('$filmes');
      return filmes;
    } else {
      throw Exception('Falha ao obter os filmes');
    }
  }

  Future<Filme> adicionarFilme(Filme filme) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(filme.toJson()),
    );

    if (response.statusCode == 201) {
      notifyListeners();
      return Filme.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add filme');
    }
    
  }

  Future<Filme> editarFilme(Filme filme) async {
    final response = await http.put(
      Uri.parse('$url/${filme.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(filme.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return Filme.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit filme');
    }
  }

  Future<void> deletarFilme(int id) async {
    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: {"Content-Type": "application/json"},
    );
    notifyListeners();

    if (response.statusCode != 204) {
      throw Exception('Failed to delete filme');
    }
  }
}
