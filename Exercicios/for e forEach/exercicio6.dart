import 'dart:io';

void main() {
  List<String> nomes = ["Ana", "Bruno", "Carlos", "Daniela", "Eduardo"];
  int presentes = 0;

  for (var nome in nomes) {
    stdout.write("A pessoa $nome está presente? (sim/não): ");
    String resposta = stdin.readLineSync()!.toLowerCase();

    if (resposta == 'sim') {
      presentes++;
    }
  }

  print("\nTotal de alunos presentes: $presentes");
}
