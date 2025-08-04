import 'dart:io';

void main() {
  print("Digite sua nota: ");
  String? entrada3 = stdin.readLineSync();
  int nota = int.parse(entrada3!);

  switch (nota) {
    case 0:
      print("Sua nota foi $nota, estude mais");
      break;
    case 1:
      print("Sua nota foi $nota, mais atençao nas aulas");
      break;
    case 2:
      print("Sua nota foi $nota, mais esforço na próxima");
      break;
    case 3:
      print("Sua nota foi $nota, nos vemos na rec");
      break;
    case 4:
      print("Sua nota foi $nota, foi quase");
      break;
    case 5:
      print("Sua nota foi $nota, na risca");
      break;
    case 6:
      print("Sua nota foi $nota, na media");
      break;
    case 7:
      print("Sua nota foi $nota, muito bom");
      break;
    case 8:
      print("Sua nota foi $nota, ótimo!");
      break;
    case 9:
      print("Sua nota foi $nota, uau!");
      break;
    case 10:
      print("Sua nota foi $nota, perfeito!");
      break;
    default:
      print("Opção Invalidada");
  }
}
