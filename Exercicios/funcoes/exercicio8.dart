import 'dart:io';

void main() {

  stdout.write("Digite o valor do produto: ");
  double preco = double.parse(stdin.readLineSync()!);

  stdout.write("Digite quanto que é o desconto: ");
  double desconto = double.parse(stdin.readLineSync()!);

  double valorFinal = calcularDesconto(preco, desconto);
  print(valorFinal);

}

double calcularDesconto(double preco, double desconto) {

  return preco - ((desconto / 100) * preco);

}