import 'dart:io';

void main() {
  List<String> props = [
    "Cortadora De Grama",
    "Cortadora da Neblina",
    "Ultimo Acorde",
    "Espada de Favounious",
    "Tumulo do Lobo",
    "Lanca de Jade",
  ];

  bool continuarComprando = true;
  double total = 0;

  do {
    print("========== SEJA BEM-VINDO ==========\nProdutos disponíveis:\n");
    for (var prop in props) {
      print("- $prop");
    }

    print("\nDigite seu CPF: ");
    String cpf = stdin.readLineSync()!;
    if (cpf.length != 11) {
      print("CPF inválido!");
      continue;
    }

    print("Digite o nome do item desejado: ");
    String input = stdin.readLineSync()!;
    if (!props.contains(input)) {
      print("Produto não encontrado!");
      continue;
    }

    print("Digite o valor do item desejado: ");
    double valor = double.tryParse(stdin.readLineSync()!) ?? -1;
    if (valor <= 0) {
      print("Valor inválido!");
      continue;
    }

    print("Produto: $input\nValor: R\$ ${valor.toStringAsFixed(2)}");
    props.remove(input);
    total += valor;

    print("Deseja continuar comprando? (S/N): ");
    String opcao = stdin.readLineSync()!;
    if (opcao.trim().toLowerCase() == "n") {
      continuarComprando = false;
    }

  } while (continuarComprando);

  bool pagamentoValido = false;
  int op = 0;

  do {
    print("\nDigite a forma de pagamento:");
    print("1 - Dinheiro");
    print("2 - Cartão de Crédito");
    print("3 - Pix");
    print("Opção: ");
    op = int.tryParse(stdin.readLineSync()!) ?? 0;

    if (op >= 1 && op <= 3) {
      pagamentoValido = true;
      switch (op) {
        case 1:
          print("Pagamento em Dinheiro selecionado.");
          break;
        case 2:
          print("Pagamento com Cartão de Crédito selecionado.");
          break;
        case 3:
          print("Pagamento via Pix selecionado.");
          break;
      }
    } else {
      print("Opção inválida. Tente novamente.");
    }

  } while (!pagamentoValido);

  print("\nCompra finalizada!");
  print("Valor total da compra: R\$ ${total.toStringAsFixed(2)}");
}
