import 'dart:io';

void main() {
  double salario = 0;

  print("Digite seu nome");
  String? nome = stdin.readLineSync();

  for (int i = 0; i < 3; i++) {
    print("Digite o seu " + (i+1).toString() + " salario: ");
    String ultimoSalario = stdin.readLineSync()!;
    double somaSalario = double.parse(ultimoSalario);
    if (somaSalario < 0) {
      print("Salario invalido");
    } else {
      salario += somaSalario;
    }
  }

  double mediaSalario = salario / 3;

  if (mediaSalario < 800) {
    print("Sua media salarial é: " + mediaSalario.toString() + ", tá precisando de um aumento em $nome");
  } else if (mediaSalario < 1518){
    print("Sua media salarial é: " + mediaSalario.toString() + ", tá suave em $nome");
  } else {
    print("Sua media salarial é: " + mediaSalario.toString() + ", tá esbanjando em $nome");
  }
  
}