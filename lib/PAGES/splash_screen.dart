import 'package:flutter/material.dart';
import 'package:receitas/PAGES/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );

    // Animação de deslizamento da faca
    _slideAnimation = Tween<double>(begin: -200.0, end: 200.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Animação de fade in/out
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Animação de faíscas
    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Navegar para Home após a animação
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Título do App
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Seu livro de receitas digital',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Animação da faca e amolador
              Positioned(
                bottom: 150,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Amolador (fixo)
                      CustomPaint(
                        size: const Size(100, 80),
                        painter: SharpenerPainter(),
                      ),

                      // Faca (deslizando)
                      Transform.translate(
                        offset: Offset(_slideAnimation.value, -20),
                        child: Transform.rotate(
                          angle: -0.3,
                          child: CustomPaint(
                            size: const Size(120, 30),
                            painter: KnifePainter(),
                          ),
                        ),
                      ),

                      // Faíscas
                      if (_sparkleAnimation.value > 0.1)
                        ...List.generate(5, (index) {
                          return Positioned(
                            left:
                                MediaQuery.of(context).size.width / 2 +
                                (index * 15.0 - 30),
                            top: 60 + (index % 2 == 0 ? 10 : -10),
                            child: Opacity(
                              opacity:
                                  _sparkleAnimation.value * (1 - index / 5),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[300],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Painter para o amolador
class SharpenerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    // Base do amolador
    final basePath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.8)
      ..close();

    canvas.drawPath(basePath, paint);

    // Parte de afiar (mais clara)
    final sharpeningPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    final sharpeningPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.3)
      ..lineTo(size.width * 0.65, size.height * 0.3)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..close();

    canvas.drawPath(sharpeningPath, sharpeningPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Painter para a faca
class KnifePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Lâmina
    final bladePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final bladePath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.3)
      ..lineTo(size.width * 0.75, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.7)
      ..close();

    canvas.drawPath(bladePath, bladePaint);

    // Brilho na lâmina
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final shinePath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.35)
      ..lineTo(size.width * 0.62, size.height * 0.4)
      ..lineTo(size.width * 0.12, size.height * 0.52)
      ..close();

    canvas.drawPath(shinePath, shinePaint);

    // Cabo
    final handlePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.fill;

    final handleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.7,
        size.height * 0.35,
        size.width * 0.3,
        size.height * 0.3,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(handleRect, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
