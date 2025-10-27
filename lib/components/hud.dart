import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'dart:math';

class HUD extends Component with HasGameRef<PixelAdventure> {
  late RectangleComponent playerAvatarFrame;
  late RectangleComponent lifeContainer;
  late List<RectangleComponent> lifeSegments;
  late SpriteComponent playerAvatar;
  late TextComponent scoreText;
  late TextComponent gameStatusText;
  late CustomPainterComponent scoreStar;

  @override
  Future<void> onLoad() async {
    playerAvatar = SpriteComponent(
      sprite: await gameRef
          .loadSprite('Main Characters/Ninja Frog/Idle (32x32).png'),
      position: Vector2(8, 8),
      size: Vector2(34, 34),
    );

    // Moldura dourada do avatar
    final playerAvatarFrame = CircleComponent(
      position: Vector2(8, 8),
      radius: 19,
      paint: Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Container do cilindro de vidas
    lifeContainer = RectangleComponent(
      position: Vector2(50, 12),
      size: Vector2(80, 18),
      paint: Paint()
        ..color = const Color(0xFF8B4513) // Marrom
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Segmentos de vida
    lifeSegments = [];
    for (int i = 0; i < 3; i++) {
      final segment = RectangleComponent(
        position: Vector2(54 + (i * 22), 14),
        size: Vector2(18, 12),
        paint: Paint()..color = const Color(0xFF8B4513), // Vermelho
      );
      lifeSegments.add(segment);
      add(segment);
    }

    scoreStar = CustomPainterComponent(
      painter: StarPainter(),
      position: Vector2(140, 8),
      size: Vector2(24, 24),
    );

    // Texto do score
    scoreText = TextComponent(
      text: '${gameRef.score} points',
      position: Vector2(140, 18),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 10,
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
    );

    gameStatusText = TextComponent(
      text: '',
      position: Vector2(280, 180),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 20,
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Adiciona componentes
    add(playerAvatarFrame);
    add(playerAvatar);
    add(lifeContainer);
    add(scoreStar);
    add(scoreText);
    add(gameStatusText);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    scoreText.text = '${gameRef.score}';

    // Atualiza vidas visuais
    for (int i = 0; i < lifeSegments.length; i++) {
      if (i < gameRef.lives) {
        lifeSegments[i].paint.color =
            const Color(0xFFFF0000); // Vermelho - vida cheia
      } else {
        lifeSegments[i].paint.color =
            const Color(0xFF444444); // Cinza - vida vazia
      }
    }

    if (gameRef.isGameOver) {
      gameStatusText.text = 'LOSER!';
    } else if (gameRef.isGameWon) {
      gameStatusText.text = 'HERO!';
    } else {
      gameStatusText.text = '';
    }

    super.update(dt);
  }
}

// Componente para desenhar rostos
class FacePainter extends CustomPainter {
  final bool isHappy;

  FacePainter({required this.isHappy});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Desenha o rosto
    final facePaint = Paint()
      ..color = const Color(0xFFFFFF00)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    // Contorno do rosto
    final outlinePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outlinePaint);

    // Desenha os olhos
    final eyePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.2), 
        radius * 0.15, eyePaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.3, center.dy - radius * 0.2), 
        radius * 0.15, eyePaint);

    // Desenha a boca
    final mouthPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    if (isHappy) {
      // Sorriso
      final mouthPath = Path();
      mouthPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.1);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.4,
        center.dx + radius * 0.4,
        center.dy + radius * 0.1,
      );
      canvas.drawPath(mouthPath, mouthPaint);
    } else {
      // Boca triste
      final mouthPath = Path();
      mouthPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.3);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.1,
        center.dx + radius * 0.4,
        center.dy + radius * 0.3,
      );
      canvas.drawPath(mouthPath, mouthPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



// Classe para desenhar uma estrela
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius / 2;
    const points = 5; // Número de pontas da estrela

    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = (i * pi / points) - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
