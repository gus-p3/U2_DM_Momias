import 'rectangulo.dart';

class Momia {
  double x;
  double y;
  final double ancho = 32;
  final double alto = 32;
  double velocidadX;
  double velocidadY;
  final double limiteIzquierdo;
  final double limiteDerecho;
  final double limiteArriba;
  final double limiteAbajo;
  final bool esVertical;
  bool derrotada = false;

  Momia({
    required this.x,
    required this.y,
    this.limiteIzquierdo = 0,
    this.limiteDerecho = 0,
    this.limiteArriba = 0,
    this.limiteAbajo = 0,
    this.velocidadX = 2,
    this.velocidadY = 2,
    this.esVertical = false,
  });

  Rectangulo get rectangulo => Rectangulo(x: x, y: y, ancho: ancho, alto: alto);

  void patrullar() {
    if (derrotada) return;

    if (esVertical) {
      y += velocidadY;
      if (y <= limiteArriba) {
        y = limiteArriba;
        velocidadY = velocidadY.abs();
      } else if (y + alto >= limiteAbajo) {
        y = limiteAbajo - alto;
        velocidadY = -velocidadY.abs();
      }
    } else {
      x += velocidadX;
      if (x <= limiteIzquierdo) {
        x = limiteIzquierdo;
        velocidadX = velocidadX.abs();
      } else if (x + ancho >= limiteDerecho) {
        x = limiteDerecho - ancho;
        velocidadX = -velocidadX.abs();
      }
    }
  }
}
