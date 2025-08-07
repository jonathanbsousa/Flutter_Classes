import 'dart:io';

void main() {
  stdout.write("Digite o valor total da compra: R\$ ");
  double valorCompra = double.parse(stdin.readLineSync()!);

  stdout.write("Digite a quantidade de parcelas: ");
  int parcelas = int.parse(stdin.readLineSync()!);

  double valorParcela = valorCompra / parcelas;

  for (int i = 1; i <= parcelas; i++) {
    print("Parcela $i: R\$ ${valorParcela.toStringAsFixed(2)}");
  }
}
