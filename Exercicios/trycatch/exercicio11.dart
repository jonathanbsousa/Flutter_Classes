import 'dart:io';

void main() {
  String op = "";

  do {
    try {
      print("==========BEM-VINDO==========");
      stdout.write("Digite seu nome completo: ");
      String? nome = stdin.readLineSync()!;

      if (nome.trim().isEmpty) {
        print("Entrada invalida!");
        continue;
      }
    } on FormatException {
      print("Escreva um opção valida!");
    } catch (e) {
      print("Entrada invalida");
    }

    print("Gostária de cadastrar mas uma pessoa?(S/N)");
    op = stdin.readLineSync()!;

    if (op.toLowerCase() == "n") {
      op = "n";
    }
  } while (op != "n");
}
