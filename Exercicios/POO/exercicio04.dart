import 'dart:io';

class Animal {
  String nome = "";
  int idade = 0;
  String? cor = "";
  String? raca = "";

  Animal({required this.nome, required this.idade, this.cor, this.raca});

  @override
  String toString() {
    return "Nome: $nome \nIdade: $idade";
  }

  void fazerSom() {
    print("Meu animal faz um som");
  }
}

class Cachorro extends Animal {
  Cachorro(
      {required String nome, required int idade, String? cor, String? raca})
      : super(nome: nome, idade: idade, cor: cor, raca: raca);

  @override
  void fazerSom() {
    print("AU AU");
  }
}

class Gato extends Animal {
  Gato({required String nome, required int idade, String? cor, String? raca})
      : super(nome: nome, idade: idade, cor: cor, raca: raca);

  @override
  void fazerSom() {
    print("Miau");
  }
}

void main() {
  List<Animal> animais = [Cachorro(nome: "Tadashi", idade: 2), Gato(nome: "Café", idade: 0)];

  for (var animal in animais) {
    animal.fazerSom();
  }
}
