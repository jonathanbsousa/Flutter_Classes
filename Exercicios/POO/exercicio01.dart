import 'dart:io';

class Produto {
  
  String nome = "";
  double preco = 0.0;
  int estoque = 0;

  Produto(this.nome, this.preco, this.estoque);

  int subtrairEstoque(){
    print("Diminuindo estoque...");
    this.estoque -= 1;
    return this.estoque; 
  }

}

void main() {

  Produto produto = Produto("Batata", 45.0, 50);

  print(produto.subtrairEstoque());
  print(produto.subtrairEstoque());
}