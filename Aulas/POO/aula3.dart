class Animal {

  void falar() {
    print("SOM");
  }
}

class Cachorro extends Animal{
  @override
  void falar() {
    print("Au AU");
  }
}

void main() {
  Animal a = Cachorro();
  a.falar();
}