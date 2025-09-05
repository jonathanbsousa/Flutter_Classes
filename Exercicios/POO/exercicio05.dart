import 'dart:io';

class Pagamento {
  double saldo;
  double? desconto;

  Pagamento({required this.saldo, this.desconto});

  void processar() {
    print("Iniciando processo de pagamento...");
  }
}

class Pix extends Pagamento {
  Pix({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);

  @override
  void processar() {
    super.processar(); 
    desconto ??= 0.15; 
    double valorFinal = saldo - (saldo * desconto!);
    print("Processando pagamento com Pix.");
    print("Você recebeu um desconto de ${(desconto! * 100).toStringAsFixed(0)}%.");
    print("Valor final: R\$ ${valorFinal.toStringAsFixed(2)}");
  }
}

class CartaoCredito extends Pagamento {
  CartaoCredito({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);

  @override
  void processar() {
    super.processar();
    print("Processando pagamento com Cartão de Crédito.");
    print("Esta modalidade de pagamento não possui desconto.");
    print("Valor a ser cobrado: R\$ ${saldo.toStringAsFixed(2)}");
  }
}

class Boleto extends Pagamento {
  Boleto({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);

  @override
  void processar() {
    super.processar();
    desconto ??= 0.10; 
    double valorFinal = saldo - (saldo * desconto!);
    print("Processando pagamento com Boleto.");
    print("O boleto foi gerado com um desconto de ${(desconto! * 100).toStringAsFixed(0)}%.");
    print("Valor final do boleto: R\$ ${valorFinal.toStringAsFixed(2)}");
  }
}

void main() {
  const double valorDaCompra = 150.0;
  print("Valor total da sua compra: R\$ ${valorDaCompra.toStringAsFixed(2)}");
  print("===================================");
  print("Escolha a forma de pagamento:");
  print("1 - Pix (15% de desconto)");
  print("2 - Cartão de Crédito (Sem desconto)");
  print("3 - Boleto (10% de desconto)");
  print("===================================");
  stdout.write("Digite sua opção: ");

  String? escolha = stdin.readLineSync();

  Pagamento? pagamento;

  switch (escolha) {
    case '1':
      pagamento = Pix(saldo: valorDaCompra);
      break;
    case '2':
      pagamento = CartaoCredito(saldo: valorDaCompra);
      break;
    case '3':
      pagamento = Boleto(saldo: valorDaCompra);
      break;
    default:
      print("Opção inválida. O programa será encerrado.");
      return;
  }
  
  print("\n--- Detalhes do Pagamento ---");
  pagamento.processar();
  print("-----------------------------");

}