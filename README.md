# U2_DM_Momias

## Momias de Guanajuato: La Leyenda
Un videojuego de plataformas 2D con física real desarrollado en Flutter, construido al 100% siguiendo la metodología **TDD (Test-Driven Development)**.

### Mecánicas Principales
- 🤠 **Personaje:** Movimiento horizontal, salto y física por gravedad con detección de colisiones de piso AABB y colisiones laterales.
- 🧟 **Momias:** IA de patrullaje entre límites configurables (horizontal y vertical). Combate con mecánica de *stomp* (saltar sobre su mitad superior las derrota y da rebote; impacto lateral resta una vida).
- 💀 **Calaveritas:** Coleccionables que suman 50 puntos cada uno.
- 💋 **Meta:** Llegar al mítico Callejón del Beso.
- 📷 **Cámara lateral:** Seguimiento horizontal dinámico del personaje centrado en pantalla.

### Retos de Extensión Completados 🎯
1. **Colisión lateral con plataformas:** Implementado `MotorFisica.resolverColisionLateral` usando el patrón de costura testable con `xAnterior`, impidiendo atravesar plataformas de costado. Probado con TDD.
2. **Vidas visuales en el HUD:** Renderizado dinámico de corazones (`Icons.favorite` / `Icons.favorite_border`) según las vidas restantes.
3. **Momias con patrullaje vertical:** Reutilización de `Momia` con soporte para movimiento vertical (`limiteArriba`, `limiteAbajo`, `esVertical`). Probado con TDD.
4. **Persistencia de récord (Mejor Puntaje):** Implementado con `shared_preferences`, guardando y mostrando el récord histórico de puntos.
5. **Segundo Nivel Extendido:** Nivel 2 de 3000px de longitud con más plataformas, calaveritas y momias tanto horizontales como verticales, reutilizando exactamente el mismo `MotorJuego`.

### Pruebas TDD
Para ejecutar la suite completa de pruebas unitarias y de integración:
```bash
flutter test
```
