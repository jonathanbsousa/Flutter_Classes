import 'dart:io';
import 'aula04.dart';

void main() {
  Carro carro = Carro(modelo: "Chevrolet Celta");
  carro.set_velocidade = 104;
  print(carro.get_velocidade);
}