import 'dart:io';

class Produto {
  
  String nome = "";
  double preco = 0.0;
  int estoque = 0;

  Produto(this.nome, this.preco, this.estoque);

  int subtrairEstoque(){
    print("Diminuindo estoque...");
    int total = this.estoque - 1;
    return total; 
  }

}

void main() {

  Produto produto = Produto("Batata", 45.0, 50);

  print(produto.subtrairEstoque());
  print(produto.subtrairEstoque());
}