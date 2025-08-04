import 'dart:io';

void main() {
  // ----------------------------------------------------------
  // int contador = 0;
  // do {
  //   print("Esse é o valor  da sua variaveis $contador");
  // } while (contador > 1);
  // ----------------------------------------------------------
  // while (contador > 1) {
  //   print("Esse é o valor  da sua variaveis $contador");
  // }
  // ----------------------------------------------------------
  // while (contador < 5) {
  //   print("${contador + 1}");
  //   contador++;
  // }
  // ----------------------------------------------------------
  // int op = 0;
  // do {
  //   print(
  //     "==========BEM-VINDO=========" +
  //         "\n1 - PIX" +
  //         "\n2 - Cartão" +
  //         "\n3 - Boleto" +
  //         "\n4 - Sair",
  //   );
  //   op = int.parse(stdin.readLineSync()!);

  //   switch (op) {
  //     case 1:
  //       print("Você escolheu pagar no PIX");
  //       break;
  //     case 2:
  //       print("Você escolheu pagar no Cartão");
  //       break;
  //     case 3:
  //       print("Você escolheu pagar no Boleto");
  //       break;
  //     case 4:
  //       print("Você escolheu sair");
  //     default:
  //       print("Opção Invalida!");
  //   }
  // } while (op != 4);
  // ----------------------------------------------------------
  // List<String> frutas = [];

  // for (int i = 0; i < 3; i++) {
  //   print("Digite sua ${i + 1}ª fruta preferida: ");
  //   String fruta = stdin.readLineSync()!;
  //   frutas.add(fruta);
  // }
  // print("Frutas: $frutas");
  // ----------------------------------------------------------
  List<String> generos = ["Terror", "Sci-Fi", "Comedia"];

  for (var i in generos) {
    print("Generos disponíveis: $i");
  }

  generos.forEach((String i) => print("$i"));
}
