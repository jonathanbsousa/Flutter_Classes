import 'dart:io';

void main() {
  double somaNotas = 0;

  for (int i = 0; i < 5; i++) {
    print("Digite a nota do aluno:");
    String nota = stdin.readLineSync()!;
    double notaAluno = double.parse(nota);
    somaNotas += notaAluno;
  }

  double media = somaNotas / 5;

  print("Média final: $media");

  if (media >= 5) {
    print("Aprovado");
  } else if (media > 4) {
    print("Recuperação");
  } else {
    print("Reprovado");
  }
}
