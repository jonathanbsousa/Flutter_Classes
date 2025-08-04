import 'dart:io';

void main() {
  int op = 0;

  do {
    print(
      "Digite a opção desejada: \n1 - Somar \n2 - Subtrair \n3 - Multiplicar \n4 - Dividir \n5 - Sair",
    );
    String? op_input = stdin.readLineSync();
    op = int.parse(op_input!);

    print("Digite um numero: ");
    String? input1 = stdin.readLineSync();
    int num1 = int.parse(input1!);

    print("Digite outro numero: ");
    String? input2 = stdin.readLineSync();
    int num2 = int.parse(input2!);

    switch (op) {
      case 1:
        print(num1 + num2);
        break;

      case 2:
        print(num1 - num2);
        break;

      case 3:
        print(num1 * num2);
        break;

      case 4:
        if (num1 == 0 || num2 == 0) {
          print("Não é possível dividir por 0");
        } else {
          print(num1 / num2);
        }
        break;

      case 5:
        print("Saindo");
        break;

      default:
        print("Opção Invalida");
    }
  } while (op < 5);

  //   // ----------------------------------------------------------

  print("Digite sua idade");
  String? entrada = stdin.readLineSync();
  int idade = int.parse(entrada!);

  if (idade >= 18) {
    print("Você pode dirigir!");
  } else if (idade == 1) {
    print("Nem pense em dirigir");
  } else {
    print("Você não pode dirigir!");
  }

  print("Ano que vem você terá " + (idade + 1).toString() + " anos");

  // // ----------------------------------------------------------
}
