import 'package:flutter_test/flutter_test.dart';
import 'package:momias/logica/momia.dart';

void main() {
  test('la momia avanza en linea recta mientras no llegue a un limite', () {
    final momia = Momia(x: 100, y: 0, limiteIzquierdo: 50, limiteDerecho: 200, velocidadX: 2);
    momia.patrullar();
    expect(momia.x, 102);
  });

  test('la momia invierte direccion al llegar al limite derecho', () {
    final momia = Momia(x: 165, y: 0, limiteIzquierdo: 50, limiteDerecho: 200, velocidadX: 2);
    momia.patrullar(); // x=167, ancho=32 -> borde derecho 199, aun no llega a 200
    momia.patrullar(); // x=169 -> borde derecho 201, ya paso el limite
    expect(momia.velocidadX, -2);
  });

  test('una momia derrotada no se mueve', () {
    final momia = Momia(x: 100, y: 0, limiteIzquierdo: 50, limiteDerecho: 200)..derrotada = true;
    momia.patrullar();
    expect(momia.x, 100);
  });

  test('la momia patrulla verticalmente entre limiteArriba y limiteAbajo', () {
    final momia = Momia(
      x: 100,
      y: 150,
      limiteIzquierdo: 0,
      limiteDerecho: 300,
      esVertical: true,
      velocidadY: 2,
      limiteArriba: 100,
      limiteAbajo: 200,
    );

    momia.patrullar();
    expect(momia.y, 152);

    // Llevar al limite inferior
    momia.y = 168; // + 32 de alto = 200 -> limiteAbajo
    momia.patrullar();
    expect(momia.velocidadY, -2);
  });
}
