import 'package:api_consumo_flutter_movies/model/movie_model.dart';
import 'package:api_consumo_flutter_movies/services/filme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaPrincipal extends StatelessWidget {
  TelaPrincipal({super.key});
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final anoController = TextEditingController();
  final fotoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home', style: TextStyle(color: Colors.white),),
            SizedBox(width: 32),
            Text('Em alta', style: TextStyle(color: Colors.white),),
            SizedBox(width: 32),
            Text('Favoritos', style: TextStyle(color: Colors.white),),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        actions: const [
           Padding(
            padding:  EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/pequenaSereia.jpg'),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/pequenaSereia.jpg',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          const Padding(
            padding:  EdgeInsets.all(32.0),
            child: Text(
              'Recomendações',
              style:  TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 400,
            child: Consumer<ApiService>(
              builder: (context, apiService, child) {
                return FutureBuilder<List<Filme>>(
                  future: apiService.listarFilmes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Erro'));
                    }

                    List<Filme> filmes = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filmes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  tituloController.text = filmes[index].titulo;
                                  descricaoController.text =
                                      filmes[index].descricao;
                                  anoController.text =
                                      filmes[index].ano.toString();
                                  fotoController.text = filmes[index].foto;
                                  showDialog(
                                      context: context,
                                      builder: (context) => modal(
                                          filmes[index].id,
                                          context,
                                          formKey,
                                          tituloController,
                                          descricaoController,
                                          anoController,
                                          fotoController,
                                          false));
                                },
                                child: Image.network(filmes[index].foto,
                                    width: 300, height: 300),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  filmes[index].titulo,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tituloController.clear();
          descricaoController.clear();
          anoController.clear();
          fotoController.clear();
          showDialog(
              context: context,
              builder: (context) => modal(1, context, formKey, tituloController,
                  descricaoController, anoController, fotoController, true));
        },
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}

Widget modal(
    int index,
    context,
    formKey,
    TextEditingController tituloController,
    TextEditingController descricaoController,
    TextEditingController anoController,
    TextEditingController fotoController,
    bool isCadastro) {
  final apiService = Provider.of<ApiService>(context);
  return SizedBox(
    height: 300,
    child: AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isCadastro ? 'Cadastrar' : 'Atualizar'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  hintText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  hintText: 'Descrição ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: anoController,
                decoration: const InputDecoration(
                  hintText: 'Ano',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: fotoController,
                decoration: const InputDecoration(
                  hintText: 'Foto',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: isCadastro
                ? () {
                    Filme novoFilme = Filme(
                      id: 1,
                      titulo: tituloController.text,
                      descricao: descricaoController.text,
                      ano: int.parse(anoController.text),
                      foto: fotoController.text,
                    );
                    apiService.adicionarFilme(novoFilme);
                    Navigator.pop(context);
                  }
                : () {
                    Filme novoFilme = Filme(
                      id: index,
                      titulo: tituloController.text,
                      descricao: descricaoController.text,
                      ano: int.parse(anoController.text),
                      foto: fotoController.text,
                    );
                    apiService.editarFilme(novoFilme);
                    Navigator.pop(context);
                  },
            child: Text(isCadastro ? 'Cadastrar' : 'Atualizar'))
      ],
    ),
  );
}
