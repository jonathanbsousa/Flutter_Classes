import 'dart:io';

void main() {
  Map<String, double> infracoes = {"Sem Infração": 0, "Infração Leve": 100, "Infração Média": 500, "Infração Grave": 1000};
  double multa = 0;

  print("Entre com o nome do motorista: ");
  String? nome = stdin.readLineSync();

  print("Entre com a velocidade do veiculo: ");
  String? kmh = stdin.readLineSync();
  double velocidade = double.parse(kmh!);

  if(velocidade <= 60){
    multa = infracoes["Sem Infração"]!;
    print("A total da multa do mostorista $nome é de $multa pois não cometou nenhuma infração");
  } else if (velocidade <= 80){
    multa = infracoes["Infração Leve"]!;
    print("A total da multa do mostorista $nome é de $multa pois cometou a infração leve");
  } else if (velocidade < 100){
    multa = infracoes["Infração Média"]!;
    print("A total da multa do mostorista $nome é de $multa pois cometou a infração média");
  } else {
    multa = infracoes["Infração Grave"]!;
    print("A total da multa do mostorista $nome é de $multa pois cometou a infração grave");
  }

  print("Escolha a forma de pagamento: \n1 - A vista \n2 - Parcelar em até 2x(sem juros) \n3 - Parcelar em até 3x (com 10% de juros)");
  String? op = stdin.readLineSync();
  int opcao = int.parse(op!);

  switch (opcao) {
    case 1:
      multa = multa - (multa * 0.1);
      print("O valor total a ser pago será de: $multa");
      break;
    case 2:
      print("O valor total a ser pago será de: $multa em 2x de " + (multa/2).toStringAsFixed(2));
      break;
    case 3:
      multa = multa + (multa * 0.1);
      print("O valor total a ser pago será de: $multa em 3x de " + (multa/3).toStringAsFixed(2));
      break;
    default:
  }
}