
const double pi = 3.14159; 

class Forma {
  double calcularArea() {
    return 0.0; 
  }
}

class Quadrado extends Forma {
  final double lado;

  Quadrado(this.lado);

  @override
  double calcularArea() {
    return lado * lado;
  }
}

class Retangulo extends Forma {
  final double base;
  final double altura;

  Retangulo(this.base, this.altura);

  @override
  double calcularArea() {
    return base * altura;
  }
}

class Circulo extends Forma {
  final double raio;

  Circulo(this.raio);

  @override
  double calcularArea() {
    return pi * raio * raio;
  }
}

void main() {
  List<Forma> formas = [];

  formas.add(Quadrado(10.0));
  formas.add(Retangulo(8.0, 5.0));
  formas.add(Circulo(7.0));
  formas.add(Quadrado(5.5));
  formas.add(Circulo(10.0));

  print("Calculando a área de diversas formas usando polimorfismo:");
  print("---------------------------------------------------------");

  for (var forma in formas) {
    String tipo = forma.runtimeType.toString();
    double area = forma.calcularArea();
    print("A área do $tipo é: ${area.toStringAsFixed(2)}");
  }

  print("---------------------------------------------------------");
}
