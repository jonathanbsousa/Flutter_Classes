import 'dart:io';
import 'dart:mirrors';

void main(){
  
  // String nome =  stdin.readLineSync()!;

  // if (nome == null || nome.trim().isEmpty){
  //   print("Existe um dado nulo ou vazio");
  // } else {
  //   print("Parabens $nome");
  // }

  // while(nome.isEmpty || nome == null){
  //   stdout.write("Digite seu nome: ");
  //   nome = stdin.readLineSync()!;
  // }

  // try {
  //   stdout.write("Digite um numero: ");
  //   int numero = int.parse(stdin.readLineSync()!);
  //   print(numero);
  // } on FormatException {
  //   print("Digite um numero!");
  // } catch (e) {
  //   print("Erro: $e");
  // } finally {
  //   print("Programa encerrado");
  // }

  List<int> lista = [1, 2, 3];

  try {
    print(lista[0]);

  } on RangeError {
    print("Digite um index valido!");
  }
   catch (e) {
    print("Erro $e");
  }
}