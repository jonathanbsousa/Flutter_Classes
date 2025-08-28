import 'dart:io';

class Veiculo {
  String nome = "";
  String modelo = "";
  int? qtd_rodas = 0;

  Veiculo({required this.nome, required this.modelo, this.qtd_rodas});
}

class Carro extends Veiculo {
  

  Carro({required String nome, required String modelo, int? qtd_rodas})
      : super(nome: nome, modelo: modelo, qtd_rodas: qtd_rodas);
}

class Moto extends Veiculo {
  

  Moto({required String nome, required String modelo, int? qtd_rodas})
      : super(nome: nome, modelo: modelo, qtd_rodas: qtd_rodas);
}

class Produto {
  String nome = "";
  double preco = 0;
  String? descricao;

  Produto({required this.nome, required this.preco, this.descricao});
}

void main() {
  Produto cocaCola = Produto(nome: "CocaCola", preco: 12);
  Produto pepsi = Produto(nome: "Pepsi", preco: 10, descricao: "Tudo de bom");

  Carro uno = Carro(nome: "Uno com escada", modelo: "Fire", qtd_rodas: 4);
  Moto kawasaki = Moto(nome: "Kawasaki",modelo: "ZX-4RR", qtd_rodas: 2);
}
