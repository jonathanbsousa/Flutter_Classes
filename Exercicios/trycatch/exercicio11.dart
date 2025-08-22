import 'dart:io';

void main() {
  String op = "";

  do {
    String nome = "";

    // Garantir que o nome seja válido
    while (true) {
      stdout.write("Digite seu nome completo: ");
      String? entrada = stdin.readLineSync();

      if (entrada == null || entrada.trim().isEmpty) {
        print("Nome inválido!");
      } else {
        nome = entrada.trim();
        break;
      }
    }

    print("Cliente cadastrado: $nome");

    // Perguntar se deseja cadastrar outra pessoa
    stdout.write("Gostaria de cadastrar mais uma pessoa? (S/N): ");
    op = (stdin.readLineSync() ?? "n").toLowerCase();

  } while (op != "n");

  print("\n👋 Cadastro finalizado!");
}
