class Pessoa {
  final String id;
  final String message;
  final String nome;
  final String email;
  Pessoa({this.id, this.message, this.nome, this.email});

  // converte o formato JSON para um objeto "Pessoa"
  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'] as String,
      message: json['message'] as String,
      nome: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
