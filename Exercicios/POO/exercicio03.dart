import 'dart:io';

class Conta {
  String nomeTitular;
  double saldoInicial;
  double investimento;

  Conta({
    required this.nomeTitular,
    required this.saldoInicial,
    this.investimento = 0.0,
  });
}

class ContaCorrente extends Conta {
  double limiteChequeEspecial;

  ContaCorrente({
    required String nomeTitular,
    required double saldoInicial,
    double investimento = 0.0,
    this.limiteChequeEspecial = 0.0,
  }) : super(
          nomeTitular: nomeTitular,
          saldoInicial: saldoInicial,
          investimento: investimento,
        );
}

class ContaPoupanca extends Conta {
  double taxaRendimento;

  ContaPoupanca({
    required String nomeTitular,
    required double saldoInicial,
    double investimento = 0.0,
    required this.taxaRendimento,
  }) : super(
          nomeTitular: nomeTitular,
          saldoInicial: saldoInicial,
          investimento: investimento,
        );

  void atualizarSaldo() {
    saldoInicial += taxaRendimento;
  }
}

void main() {
  ContaCorrente contaCorrente = ContaCorrente(nomeTitular: "Jonathan", saldoInicial: 2000.52);

  ContaPoupanca contaPoupanca = ContaPoupanca(nomeTitular: "Jonathan", saldoInicial: 100.58, taxaRendimento: 50);

  contaPoupanca.atualizarSaldo();
  print(contaPoupanca.saldoInicial);
}
