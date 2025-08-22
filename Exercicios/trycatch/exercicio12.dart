import 'dart:io';

void main() {
  double valorCompra = lerValorCompra();
  int formaPagamento = escolherFormaPagamento();

  print("\nResumo da Compra:");
  print("Valor: R\$ ${valorCompra.toStringAsFixed(2)}");
  print("Forma de pagamento: ${descricaoPagamento(formaPagamento)}");
}

double lerValorCompra() {
  double? valor;
  while (valor == null || valor <= 0) {
    stdout.write("Digite o valor da compra: ");
    String? entrada = stdin.readLineSync();

    try {
      valor = double.parse(entrada ?? "");
      if (valor <= 0) {
        print("O valor deve ser maior que zero.\n");
        valor = null;
      }
    } on FormatException {
      print("Valor inválido! Digite apenas números.");
    }
  }
  return valor;
}

int escolherFormaPagamento() {
  int? opcao;
  while (opcao == null || opcao < 1 || opcao > 4) {
    print("\nEscolha a forma de pagamento:");
    print("1 - Dinheiro");
    print("2 - Cartão de Débito");
    print("3 - Cartão de Crédito");
    print("4 - Pix");
    stdout.write("Opção: ");
    String? entrada = stdin.readLineSync();

    try {
      opcao = int.parse(entrada ?? "");
      if (opcao < 1 || opcao > 4) {
        print("Opção inválida!");
        opcao = null;
      }
    } on FormatException {
      print("❌ Digite apenas números entre 1 e 4.\n");
    }
  }
  return opcao;
}

String descricaoPagamento(int opcao) {
  switch (opcao) {
    case 1:
      return "Dinheiro";
    case 2:
      return "Cartão de Débito";
    case 3:
      return "Cartão de Crédito";
    case 4:
      return "Pix";
    default:
      return "Desconhecido";
  }
}
