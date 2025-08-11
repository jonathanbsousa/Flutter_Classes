import 'dart:io';

void main() {
  stdout.write("Digiete a temperatura em celsius: ");
  double celsius = double.parse(stdin.readLineSync()!);

  print(celsiusParaFahrenheit(celsius));
}

double celsiusParaFahrenheit(double celsius) {
  return (celsius * 9/5) + 32;
}