// import 'dart:io';

// void main() {
//     Humano jonathan = Humano("Nome", "Masculino", 1.75);
//     // jonathan.nome = "Jonathan";
//     // jonathan.genero = "Masculino";
//     // jonathan.altura = 1.75;

//     print("${jonathan.nome} ${jonathan.genero} ${jonathan.altura}");
    
//     Humano nicole = Humano("Nicole", "Feminino", 1.59);
//     // nicole.nome = "Nicole";
//     // nicole.genero = "Feminino";
//     // nicole.altura = 1.59;
    
//     print("${nicole.nome} ${nicole.genero} ${nicole.altura}");

//     Humano allison = Humano("Allison", "Masculino", 1.65);
//     // allison.nome = "Allison";
//     // allison.genero = "Masculino";
//     // allison.altura = 1.65;
    
//     print("${allison.nome} ${allison.genero} ${allison.altura}");

//     Carro uno = Carro("Banco", "Uno Fire 0.8", "Fiat", "Escada", 0.0);
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();
//     uno.acelerar();

//     print("${uno.modelo}, ${uno.velocidade} Km/h");

// }

// class Humano {
//     String nome = "";
//     String genero = "";
//     double altura = 0.0;

//     Humano(this.nome, this.genero, this.altura);

// }   

// class Carro {
//     String cor = "";
//     String modelo = "";
//     String marca = "";
//     String acesorio = "";
//     double velocidade = 0.0;

//     Carro(this.cor, this.modelo, this.marca, this.acesorio, this.velocidade);

//     void acelerar() {
//         velocidade += 10;
//     }

// }

class Carro {
    String marca;
    Carro(this.marca);
}

void main() {
Carro c = Carro("Fiat");
print(c.marca);
}