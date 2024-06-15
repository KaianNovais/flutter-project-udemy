class Filme {
  //variáveis
  final int id;
  final String titulo;
  final String descricao;
  final int ano;
  final String foto;

  //construtor
  Filme({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ano,
    required this.foto,
  });

  //obter o json
  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      ano: json['ano'],
      foto: json['foto'],
    );
  }

  //converter o filme em json
  Map<String, dynamic> toJson() {
    return {"titulo": titulo, "descricao": descricao, "ano": ano, "foto": foto};
  }

  @override
  String toString() {
    return 'Título: $titulo';
  }
}
