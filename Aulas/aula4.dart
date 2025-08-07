import 'dart:io';

void main() {
  mostrar();
  soma(10, 20);
  String valor_dafuncao = nome("Jonathan");
  print("$valor_dafuncao");
}

void mostrar() {
  print("Olá seu nome é Jonathan");
}

void soma(int a, int b) {
  int valor = a + b;
  print("$valor");
}

String nome (String nome) {
  return "O seu nome é $nome";
}