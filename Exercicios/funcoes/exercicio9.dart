import 'dart:io';
import 'dart:mirrors';

void main() {

  stdout.write("Digite sua idade: ");
  int idade = int.parse(stdin.readLineSync()!);

  print(ehMaiorIdade(idade));

}

bool ehMaiorIdade(int idade) {
  if (idade >= 18){
    print("É maior de idade");
    return true;
  } else {
    print("Não é maior de idade");
    return false;
  }
}