class Pagamento {
  double saldo = 0.0;
  double? desconto = 0.0;

  Pagamento({required this.saldo, this.desconto});

  void processar() {
    print("Indo para pagamento");
  }
}

class Pix extends Pagamento {
  Pix({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);

  @override
  void processar() {
    
  }
}

class CartaoCredito extends Pagamento {
  CartaoCredito({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);
}

class Boleto extends Pagamento {
  Boleto({required double saldo, double? desconto})
      : super(saldo: saldo, desconto: desconto);
}
