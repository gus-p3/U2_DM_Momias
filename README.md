# U2_DM_Momias

## Momias de Guanajuato: La Leyenda
Un videojuego de plataformas 2D con física real desarrollado en Flutter, construido al 100% siguiendo la metodología **TDD (Test-Driven Development)**.

### Mecánicas
- 🤠 **Personaje:** Movimiento horizontal, salto y física por gravedad con detección de colisiones de piso AABB.
- 🧟 **Momias:** IA de patrullaje entre límites configurables. Combate con mecánica de *stomp* (saltar sobre su mitad superior las derrota y da rebote; impacto lateral resta una vida).
- 💀 **Calaveritas:** Coleccionables que suman 50 puntos cada uno.
- 💋 **Meta:** Llegar al mítico Callejón del Beso (x >= 1900).
- 📷 **Cámara lateral:** Seguimiento horizontal dinámico del personaje centrado en pantalla.

### Pruebas TDD
Para ejecutar la suite completa de pruebas unitarias y de integración:
```bash
flutter test
```
