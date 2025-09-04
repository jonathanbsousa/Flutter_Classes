import 'dart:io';

class Carro{
  String modelo = "";
  int _velocidade = 0;

  Carro({required this.modelo});

  int get get_velocidade {
    return _velocidade;
  }

  set set_velocidade(int velocidade) {
    if(velocidade < 0){
      print("A velocidade não pode ser menor que zero");
    } else {
      _velocidade = velocidade;
    }
  }

}