import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logica/motor_juego.dart';
import '../logica/personaje.dart';
import '../logica/momia.dart';
import '../logica/calaverita.dart';
import '../logica/rectangulo.dart';
import '../logica/estado_juego.dart';

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});
  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  Timer? _bucle;
  double _direccion = 0;
  final FocusNode _focusNode = FocusNode();

  int _nivelActual = 1;
  int _mejorPuntaje = 0;

  @override
  void initState() {
    super.initState();
    _cargarMejorPuntaje();
    _iniciarNivel(_nivelActual);
    _iniciarBucle();
  }

  Future<void> _cargarMejorPuntaje() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mejorPuntaje = prefs.getInt('mejor_puntaje') ?? 0;
    });
  }

  Future<void> _guardarMejorPuntaje(int puntaje) async {
    if (puntaje > _mejorPuntaje) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('mejor_puntaje', puntaje);
      setState(() {
        _mejorPuntaje = puntaje;
      });
    }
  }

  void _iniciarNivel(int nivel) {
    _nivelActual = nivel;
    if (nivel == 1) {
      _motor = MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 2000, alto: 40),
          Rectangulo(x: 300, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 550, y: 160, ancho: 120, alto: 20),
        ],
        momias: [
          // Momia horizontal
          Momia(x: 320, y: 268, limiteIzquierdo: 300, limiteDerecho: 420),
          Momia(x: 900, y: 268, limiteIzquierdo: 850, limiteDerecho: 1100),
          // Momia con patrullaje vertical (sube y baja)
          Momia(
            x: 750,
            y: 120,
            limiteIzquierdo: 700,
            limiteDerecho: 800,
            esVertical: true,
            velocidadY: 2,
            limiteArriba: 80,
            limiteAbajo: 268,
          ),
        ],
        calaveritas: [
          Calaverita(x: 360, y: 180),
          Calaverita(x: 600, y: 120),
          Calaverita(x: 1200, y: 260),
        ],
        posicionMeta: 1900,
        anchoNivel: 2000,
      );
    } else {
      // Nivel 2: Más largo (3000px), más plataformas y más momias horizontales y verticales
      _motor = MotorJuego(
        personaje: Personaje(x: 20, y: 100),
        plataformas: const [
          Rectangulo(x: 0, y: 300, ancho: 3000, alto: 40),
          Rectangulo(x: 250, y: 230, ancho: 110, alto: 20),
          Rectangulo(x: 450, y: 170, ancho: 110, alto: 20),
          Rectangulo(x: 680, y: 120, ancho: 130, alto: 20),
          Rectangulo(x: 950, y: 200, ancho: 120, alto: 20),
          Rectangulo(x: 1200, y: 150, ancho: 140, alto: 20),
          Rectangulo(x: 1500, y: 220, ancho: 120, alto: 20),
          Rectangulo(x: 1800, y: 160, ancho: 120, alto: 20),
          Rectangulo(x: 2100, y: 120, ancho: 140, alto: 20),
          Rectangulo(x: 2400, y: 200, ancho: 130, alto: 20),
        ],
        momias: [
          Momia(x: 280, y: 268, limiteIzquierdo: 250, limiteDerecho: 450),
          // Momias verticales
          Momia(
            x: 580,
            y: 100,
            esVertical: true,
            velocidadY: 2.5,
            limiteArriba: 60,
            limiteAbajo: 268,
          ),
          Momia(x: 1000, y: 268, limiteIzquierdo: 950, limiteDerecho: 1250),
          Momia(
            x: 1380,
            y: 80,
            esVertical: true,
            velocidadY: 3,
            limiteArriba: 50,
            limiteAbajo: 268,
          ),
          Momia(x: 1600, y: 268, limiteIzquierdo: 1500, limiteDerecho: 1850),
          Momia(
            x: 1980,
            y: 100,
            esVertical: true,
            velocidadY: 2.5,
            limiteArriba: 60,
            limiteAbajo: 268,
          ),
          Momia(x: 2200, y: 268, limiteIzquierdo: 2100, limiteDerecho: 2450),
        ],
        calaveritas: [
          Calaverita(x: 300, y: 190),
          Calaverita(x: 500, y: 130),
          Calaverita(x: 740, y: 80),
          Calaverita(x: 1000, y: 160),
          Calaverita(x: 1260, y: 110),
          Calaverita(x: 1550, y: 180),
          Calaverita(x: 1850, y: 120),
          Calaverita(x: 2160, y: 80),
          Calaverita(x: 2450, y: 160),
          Calaverita(x: 2750, y: 260),
        ],
        posicionMeta: 2850,
        anchoNivel: 3000,
      );
    }
  }

  void _iniciarBucle() {
    _bucle?.cancel();
    _bucle = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      setState(() {
        _motor.mover(_direccion * 4);
      });
      if (_motor.estado != EstadoJuego.jugando) {
        _bucle?.cancel();
        _mostrarResultado();
      }
    });
  }

  @override
  void dispose() {
    _bucle?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _mostrarResultado() {
    final gano = _motor.estado == EstadoJuego.ganado;
    _guardarMejorPuntaje(_motor.puntaje);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
        child: FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            title: Text(gano
                ? (_nivelActual == 1
                    ? '¡Nivel 1 Superado! Llegaste al Callejón'
                    : '¡Victoria Total! Eres la Leyenda de Guanajuato')
                : '¡Las momias te atraparon!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Puntaje: ${_motor.puntaje}'),
                Text('Mejor puntaje: $_mejorPuntaje', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              ],
            ),
            actions: [
              if (gano && _nivelActual == 1)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _direccion = 0;
                      _iniciarNivel(2);
                    });
                    _iniciarBucle();
                  },
                  child: const Text('Pasar al Nivel 2'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _direccion = 0;
                    _iniciarNivel(_nivelActual);
                  });
                  _iniciarBucle();
                },
                child: Text(gano && _nivelActual == 1 ? 'Reintentar Nivel 1' : 'Jugar de nuevo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _manejarTecla(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        setState(() => _direccion = -1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        setState(() => _direccion = 1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        setState(() => _motor.saltar());
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyA ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        setState(() => _direccion = 0);
      }
    }
  }

  Widget _renderizarCorazones(int vidas) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < vidas ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
            size: 22,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _manejarTecla,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Momias de Guanajuato - Nivel $_nivelActual'),
          actions: [
            IconButton(
              icon: Icon(_nivelActual == 1 ? Icons.looks_two : Icons.looks_one),
              tooltip: 'Cambiar de Nivel',
              onPressed: () {
                setState(() {
                  _direccion = 0;
                  _iniciarNivel(_nivelActual == 1 ? 2 : 1);
                });
                _iniciarBucle();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Vidas: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _renderizarCorazones(_motor.vidas),
                    ],
                  ),
                  Row(
                    children: [
                      Text('🏆 Récord: $_mejorPuntaje  ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      Text('Puntos: ${_motor.puntaje}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final anchoVentana = constraints.maxWidth > 0 ? constraints.maxWidth : 360.0;
                  final maxCamara = (_motor.anchoNivel - anchoVentana).clamp(0.0, _motor.anchoNivel);
                  final camaraX = (_motor.personaje.x - anchoVentana / 2).clamp(0.0, maxCamara);

                  return ClipRect(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _nivelActual == 1
                                    ? [const Color(0xFFFFE0B2), const Color(0xFFFFCC80)]
                                    : [const Color(0xFFFFCCBC), const Color(0xFFFFAB91)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Plataformas
                        ..._motor.plataformas.map((pl) => Positioned(
                              left: pl.x - camaraX,
                              top: pl.y,
                              child: Container(
                                width: pl.ancho,
                                height: pl.alto,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE91E63),
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )),
                        // Meta (Callejón del Beso)
                        Positioned(
                          left: _motor.posicionMeta - camaraX,
                          top: 240,
                          child: Column(
                            children: const [
                              Text('💋', style: TextStyle(fontSize: 28)),
                              Text('META', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                            ],
                          ),
                        ),
                        // Calaveritas
                        ..._motor.calaveritas.where((c) => !c.recolectada).map((c) => Positioned(
                              left: c.x - camaraX,
                              top: c.y,
                              child: const Text('💀', style: TextStyle(fontSize: 20)),
                            )),
                        // Momias
                        ..._motor.momias.where((m) => !m.derrotada).map((m) => Positioned(
                              left: m.x - camaraX,
                              top: m.y,
                              child: Container(
                                width: m.ancho,
                                height: m.alto,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD7CCC8),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.black38),
                                ),
                                alignment: Alignment.center,
                                child: const Text('🧟', style: TextStyle(fontSize: 18)),
                              ),
                            )),
                        // Personaje
                        Positioned(
                          left: _motor.personaje.x - camaraX,
                          top: _motor.personaje.y,
                          child: Container(
                            width: _motor.personaje.ancho,
                            height: _motor.personaje.alto,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🤠', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    _boton(
                      Icons.arrow_back,
                      () => setState(() => _direccion = -1),
                      () => setState(() => _direccion = 0),
                    ),
                    const SizedBox(width: 16),
                    _boton(
                      Icons.arrow_forward,
                      () => setState(() => _direccion = 1),
                      () => setState(() => _direccion = 0),
                    ),
                  ]),
                  _boton(
                    Icons.arrow_upward,
                    () => setState(() => _motor.saltar()),
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boton(IconData icono, VoidCallback alPresionar, VoidCallback alSoltar) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => alPresionar(),
      onPointerUp: (_) => alSoltar(),
      onPointerCancel: (_) => alSoltar(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () {},
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo,
            child: Icon(icono, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
