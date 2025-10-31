// // import 'package:flame/components.dart';
// // import 'package:flame/text.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:pixel_adventure/pixel_adventure.dart';

// // class HUD extends PositionComponent with HasGameRef<PixelAdventure> {
// //   // ===== Configuração ESTÁTICA =====
// //   static const double uiScale = 0.70;
// //   static const double marginLeft = 36;
// //   static const double marginTop = 28;
// //   static const double safeBleed = 10;
// //   static const double gapH = 10;
// //   static const double gapV = 8;
// //   static const double avatarHFactor = 0.95;

// //   // Backplate (fundo) atrás dos painéis
// //   static const Color plateColor = Color(0xFF2A2140);
// //   static const double plateInset = 4;

// //   // ===== Componentes =====
// //   late final SpriteComponent avatar;
// //   late final SpriteComponent lifePanel;
// //   late final SpriteComponent scorePanel;

// //   late final RectangleComponent lifeBack;
// //   late final RectangleComponent scoreBack;

// //   late final TextComponent scoreText;
// //   late final TextComponent gameStatusText;

// //   // Sprites
// //   late Sprite _life3, _life2, _life1, _life0;
// //   late Sprite _scoreSprite;

// //   // Tamanho real do PNG do painel
// //   late Vector2 _panelBaseSize;

// //   @override
// //   Future<void> onLoad() async {
// //     priority = 1000; // Alta prioridade para ficar na frente

// //     // Configura o HUD como PositionComponent direto
// //     anchor = Anchor.topLeft;
// //     position = Vector2(marginLeft + safeBleed, marginTop + safeBleed);

// //     // Score primeiro para ler o tamanho real do PNG
// //     _scoreSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
// //     _panelBaseSize = _scoreSprite.srcSize.clone();

// //     // Sprites de vidas
// //     _life3 = await gameRef.loadSprite('Other/Dust Particle.png');
// //     _life2 = await gameRef.loadSprite('Other/Shadow.png');
// //     _life1 = await gameRef.loadSprite('Other/Transition.png');
// //     _life0 = await gameRef.loadSprite('Other/Shadow.png');

// //     // Componentes principais
// //     lifePanel = SpriteComponent(sprite: _life3, anchor: Anchor.topLeft)
// //       ..paint.filterQuality = FilterQuality.none;

// //     scorePanel = SpriteComponent(sprite: _scoreSprite, anchor: Anchor.topLeft)
// //       ..paint.filterQuality = FilterQuality.none;

// //     avatar = SpriteComponent(
// //       sprite: await gameRef.loadSprite('Main Characters/Ninja Frog/Idle (32x32).png'),
// //       anchor: Anchor.topLeft,
// //     )..paint.filterQuality = FilterQuality.none;

// //     // Backplates
// //     lifeBack = RectangleComponent(
// //       anchor: Anchor.topLeft,
// //       paint: Paint()..color = plateColor
// //     );
// //     scoreBack = RectangleComponent(
// //       anchor: Anchor.topLeft,
// //       paint: Paint()..color = plateColor
// //     );

// //     // Texto do score
// //     scoreText = TextComponent(
// //       text: '0',
// //       anchor: Anchor.topLeft,
// //       textRenderer: TextPaint(
// //         style: GoogleFonts.vt323(
// //           textStyle: const TextStyle(
// //             fontSize: 28,
// //             color: Color(0xFFFFF1C4),
// //             shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
// //           ),
// //         ),
// //       ),
// //     );

// //     // Status (topo-centro da tela)
// //     gameStatusText = TextComponent(
// //       text: '',
// //       anchor: Anchor.topCenter,
// //       textRenderer: TextPaint(
// //         style: GoogleFonts.vt323(
// //           textStyle: const TextStyle(
// //             fontSize: 24,
// //             color: Color(0xFFFFD700),
// //             fontWeight: FontWeight.w700,
// //             shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
// //           ),
// //         ),
// //       ),
// //     );

// //     // Adiciona todos os componentes diretamente ao HUD
// //     addAll([avatar, lifeBack, lifePanel, scoreBack, scorePanel, scoreText]);

// //     // Adiciona o gameStatusText diretamente à viewport para ficar acima de tudo
// //     gameRef.camera.viewport.add(gameStatusText);

// //     _layout();
// //     super.onLoad();
// //   }

// //   Sprite _spriteForLives(int lives) {
// //     if (lives <= 0) return _life0;
// //     if (lives == 1) return _life1;
// //     if (lives == 2) return _life2;
// //     return _life3;
// //   }

// //   void _layout() {
// //     final vp = gameRef.camera.viewport.size;

// //     // Escala final
// //     final double s = uiScale;

// //     // Tamanhos FINAIS
// //     final Vector2 panelSize = _snap(_panelBaseSize * s);
// //     lifePanel
// //       ..size = panelSize
// //       ..sprite = _spriteForLives(gameRef.lives);
// //     scorePanel.size = panelSize;

// //     // Avatar
// //     final double avatarH = panelSize.y * avatarHFactor;
// //     avatar.size = _snap(Vector2.all(avatarH));

// //     // POSIÇÕES RELATIVAS (dentro do HUD)
// //     avatar.position = _snap(Vector2(0, (panelSize.y - avatarH) / 2));
// //     lifeBack.position = _snap(Vector2(avatar.size.x + gapH, 0));
// //     lifePanel.position = lifeBack.position.clone();

// //     scoreBack.position = _snap(Vector2(lifePanel.position.x, panelSize.y + gapV));
// //     scorePanel.position = scoreBack.position.clone();

// //     // Backplates
// //     final double inset = plateInset * s;
// //     lifeBack.size = _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));
// //     scoreBack.size = _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));

// //     // Ajuste do backplate
// //     lifeBack.position = _snap(lifePanel.position + Vector2(inset, inset));
// //     scoreBack.position = _snap(scorePanel.position + Vector2(inset, inset));

// //     // Texto dentro do painel de score
// //     final Vector2 scoreTextOffset = _snap(Vector2(66 * s, 20 * s));
// //     scoreText
// //       ..text = '${gameRef.score}'
// //       ..position = _snap(scorePanel.position + scoreTextOffset);

// //     // Tamanho do HUD baseado no conteúdo
// //     final double hudWidth = avatar.size.x + gapH + panelSize.x;
// //     final double hudHeight = panelSize.y + gapV + panelSize.y;
// //     size = Vector2(hudWidth, hudHeight);

// //     // Posiciona o status text no topo da tela
// //     gameStatusText.position = Vector2(vp.x / 2, marginTop);
// //   }

// //   // Arredonda para evitar sub-pixel
// //   Vector2 _snap(Vector2 v) => Vector2(v.x.roundToDouble(), v.y.roundToDouble());

// //   @override
// //   void onGameResize(Vector2 size) {
// //     super.onGameResize(size);
// //     _layout();
// //   }

// //   @override
// //   void update(double dt) {
// //     // Atualiza score e sprite das vidas
// //     scoreText.text = '${gameRef.score}';
// //     lifePanel.sprite = _spriteForLives(gameRef.lives);

// //     if (gameRef.isGameOver) {
// //       gameStatusText.text = 'LOSER!';
// //     } else if (gameRef.isGameWon) {
// //       gameStatusText.text = 'HERO!';
// //     } else {
// //       gameStatusText.text = '';
// //     }
// //     super.update(dt);
// //   }
// // }

// import 'package:flame/components.dart';
// import 'package:flame/text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pixel_adventure/pixel_adventure.dart';

// class HUD extends PositionComponent with HasGameRef<PixelAdventure> {
//   // ===== Configuração ESTÁTICA =====
//   static const double uiScale = 0.70;
//   static const double marginLeft = 36;
//   static const double marginTop = 28;
//   static const double safeBleed = 10;
//   static const double gapH = 10;
//   static const double gapV = 8;
//   static const double avatarHFactor = 0.95;

//   // Backplate (fundo) atrás dos painéis
//   static const Color plateColor = Color(0xFF2A2140);
//   static const double plateInset = 4;

//   // ===== Componentes =====
//   late final SpriteComponent avatar;
//   late final SpriteComponent lifePanel;
//   late final SpriteComponent scorePanel;

//   late final RectangleComponent lifeBack;
//   late final RectangleComponent scoreBack;

//   late final TextComponent scoreText;
//   late final TextComponent gameStatusText;

//   // Sprites
//   late Sprite _life3, _life2, _life1, _life0;
//   late Sprite _scoreSprite;

//   // Tamanho real do PNG do painel
//   late Vector2 _panelBaseSize;

//   @override
//   Future<void> onLoad() async {
//     priority = 1000; // Alta prioridade para ficar na frente

//     // Configura o HUD como PositionComponent direto
//     anchor = Anchor.topLeft;
//     position = Vector2(marginLeft + safeBleed, marginTop + safeBleed);

//     // Score primeiro para ler o tamanho real do PNG
//     _scoreSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
//     _panelBaseSize = _scoreSprite.srcSize.clone();

//     // Sprites de vidas
//     _life3 = await gameRef.loadSprite('Other/Dust Particle.png');
//     _life2 = await gameRef.loadSprite('Other/Shadow.png');
//     _life1 = await gameRef.loadSprite('Other/Transition.png');
//     _life0 = await gameRef.loadSprite('Other/Shadow.png');

//     // Componentes principais
//     lifePanel = SpriteComponent(sprite: _life3, anchor: Anchor.topLeft)
//       ..paint.filterQuality = FilterQuality.none;

//     scorePanel = SpriteComponent(sprite: _scoreSprite, anchor: Anchor.topLeft)
//       ..paint.filterQuality = FilterQuality.none;

//     avatar = SpriteComponent(
//       sprite: await gameRef.loadSprite('Main Characters/Ninja Frog/Idle (32x32).png'),
//       anchor: Anchor.topLeft,
//     )..paint.filterQuality = FilterQuality.none;

//     // Backplates
//     lifeBack = RectangleComponent(
//       anchor: Anchor.topLeft,
//       paint: Paint()..color = plateColor
//     );
//     scoreBack = RectangleComponent(
//       anchor: Anchor.topLeft,
//       paint: Paint()..color = plateColor
//     );

//     // Texto do score
//     scoreText = TextComponent(
//       text: '0',
//       anchor: Anchor.topLeft,
//       textRenderer: TextPaint(
//         style: GoogleFonts.vt323(
//           textStyle: const TextStyle(
//             fontSize: 28,
//             color: Color(0xFFFFF1C4),
//             shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
//           ),
//         ),
//       ),
//     );

//     // Status (topo-centro da tela)
//     gameStatusText = TextComponent(
//       text: '',
//       anchor: Anchor.topCenter,
//       textRenderer: TextPaint(
//         style: GoogleFonts.vt323(
//           textStyle: const TextStyle(
//             fontSize: 24,
//             color: Color(0xFFFFD700),
//             fontWeight: FontWeight.w700,
//             shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
//           ),
//         ),
//       ),
//     );

//     // Adiciona todos os componentes diretamente ao HUD
//     addAll([avatar, lifeBack, lifePanel, scoreBack, scorePanel, scoreText]);

//     // Adiciona o gameStatusText diretamente à viewport para ficar acima de tudo
//     gameRef.camera.viewport.add(gameStatusText);

//     _layout();
//     super.onLoad();
//   }

//   Sprite _spriteForLives(int lives) {
//     if (lives <= 0) return _life0;
//     if (lives == 1) return _life1;
//     if (lives == 2) return _life2;
//     return _life3;
//   }

//   void _layout() {
//     final vp = gameRef.camera.viewport.size;

//     // Escala final
//     final double s = uiScale;

//     // Tamanhos FINAIS
//     final Vector2 panelSize = _snap(_panelBaseSize * s);
//     lifePanel
//       ..size = panelSize
//       ..sprite = _spriteForLives(gameRef.lives);
//     scorePanel.size = panelSize;

//     // Avatar
//     final double avatarH = panelSize.y * avatarHFactor;
//     avatar.size = _snap(Vector2.all(avatarH));

//     // POSIÇÕES RELATIVAS (dentro do HUD)
//     avatar.position = _snap(Vector2(0, (panelSize.y - avatarH) / 2));
//     lifeBack.position = _snap(Vector2(avatar.size.x + gapH, 0));
//     lifePanel.position = lifeBack.position.clone();

//     scoreBack.position = _snap(Vector2(lifePanel.position.x, panelSize.y + gapV));
//     scorePanel.position = scoreBack.position.clone();

//     // Backplates
//     final double inset = plateInset * s;
//     lifeBack.size = _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));
//     scoreBack.size = _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));

//     // Ajuste do backplate
//     lifeBack.position = _snap(lifePanel.position + Vector2(inset, inset));
//     scoreBack.position = _snap(scorePanel.position + Vector2(inset, inset));

//     // Texto dentro do painel de score
//     final Vector2 scoreTextOffset = _snap(Vector2(66 * s, 20 * s));
//     scoreText
//       ..text = '${gameRef.score}'
//       ..position = _snap(scorePanel.position + scoreTextOffset);

//     // Tamanho do HUD baseado no conteúdo
//     final double hudWidth = avatar.size.x + gapH + panelSize.x;
//     final double hudHeight = panelSize.y + gapV + panelSize.y;
//     size = Vector2(hudWidth, hudHeight);

//     // Posiciona o status text no topo da viewport
//     gameStatusText.position = Vector2(vp.x / 2, marginTop);
//   }

//   // Arredonda para evitar sub-pixel
//   Vector2 _snap(Vector2 v) => Vector2(v.x.roundToDouble(), v.y.roundToDouble());

//   @override
//   void onGameResize(Vector2 size) {
//     super.onGameResize(size);
//     _layout();
//   }

//   @override
//   void update(double dt) {
//     // Atualiza score e sprite das vidas
//     scoreText.text = '${gameRef.score}';
//     lifePanel.sprite = _spriteForLives(gameRef.lives);

//     if (gameRef.isGameOver) {
//       gameStatusText.text = 'LOSER!';
//     } else if (gameRef.isGameWon) {
//       gameStatusText.text = 'HERO!';
//     } else {
//       gameStatusText.text = '';
//     }
//     super.update(dt);
//   }
// }

// import 'package:flame/components.dart';
// import 'package:flame/text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pixel_adventure/pixel_adventure.dart';

// class HUD extends PositionComponent with HasGameRef<PixelAdventure> {
//   // ===== Configuração ESTÁTICA =====
//   static const double uiScale = 0.70;
//   static const double marginLeft = 36;
//   static const double marginTop = 28;
//   static const double safeBleed = 10;
//   static const double gapH = 10;
//   static const double gapV = 8;
//   static const double avatarHFactor = 0.95;

//   // Backplate (fundo) atrás dos painéis
//   static const Color plateColor = Color(0xFF2A2140);
//   static const double plateInset = 4;

//   // ===== Componentes =====
//   late final SpriteComponent avatar;
//   late final SpriteComponent lifePanel;
//   late final SpriteComponent scorePanel;

//   late final RectangleComponent lifeBack;
//   late final RectangleComponent scoreBack;

//   late final TextComponent scoreText;

//   // Substitui TextComponent por SpriteComponent para imagens
//   late final SpriteComponent gameStatusImage;

//   // Sprites
//   late Sprite _life3, _life2, _life1, _life0;
//   late Sprite _scoreSprite;
//   late Sprite _gameOverSprite;
//   late Sprite _gameWonSprite;

//   // Tamanho real do PNG do painel
//   late Vector2 _panelBaseSize;

//   @override
//   Future<void> onLoad() async {
//     priority = 1000;

//     // Configura o HUD como PositionComponent direto
//     anchor = Anchor.topLeft;
//     position = Vector2(marginLeft + safeBleed, marginTop + safeBleed);

//     // Score primeiro para ler o tamanho real do PNG
//     _scoreSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
//     _panelBaseSize = _scoreSprite.srcSize.clone();

//     // Sprites de vidas
//     _life3 = await gameRef.loadSprite('Other/Dust Particle.png');
//     _life2 = await gameRef.loadSprite('Other/Shadow.png');
//     _life1 = await gameRef.loadSprite('Other/Transition.png');
//     _life0 = await gameRef.loadSprite('Other/Shadow.png');

//     // Sprites para game over e vitória (adicione suas imagens)
//     _gameOverSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
//     _gameWonSprite = await gameRef.loadSprite('Other/Shadow.png');

//     // Componentes principais
//     lifePanel = SpriteComponent(sprite: _life3, anchor: Anchor.topLeft)
//       ..paint.filterQuality = FilterQuality.none;

//     scorePanel = SpriteComponent(sprite: _scoreSprite, anchor: Anchor.topLeft)
//       ..paint.filterQuality = FilterQuality.none;

//     avatar = SpriteComponent(
//       sprite: await gameRef
//           .loadSprite('Main Characters/Ninja Frog/Idle (32x32).png'),
//       anchor: Anchor.topLeft,
//     )..paint.filterQuality = FilterQuality.none;

//     // Backplates
//     lifeBack = RectangleComponent(
//         anchor: Anchor.topLeft, paint: Paint()..color = plateColor);
//     scoreBack = RectangleComponent(
//         anchor: Anchor.topLeft, paint: Paint()..color = plateColor);

//     // Texto do score
//     scoreText = TextComponent(
//       text: '0',
//       anchor: Anchor.topLeft,
//       textRenderer: TextPaint(
//         style: GoogleFonts.vt323(
//           textStyle: const TextStyle(
//             fontSize: 28,
//             color: Color(0xFFFFF1C4),
//             shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
//           ),
//         ),
//       ),
//     );

//     // Componente de imagem para status do jogo (inicialmente invisível)
//     gameStatusImage = SpriteComponent(
//       sprite: _gameOverSprite, // Sprite padrão
//       anchor: Anchor.center,
//       size: Vector2(300, 150), // Tamanho da imagem (ajuste conforme necessário)
//     )..paint.filterQuality = FilterQuality.none
//     ..priority = 20000
//     ..opacity = 0; // Começa invisível

//     // Adiciona todos os componentes diretamente ao HUD
//     addAll([avatar, lifeBack, lifePanel, scoreBack, scorePanel, scoreText]);

//     // Adiciona a imagem de status diretamente à viewport para ficar acima de tudo
//     gameRef.add(gameStatusImage);

//     _layout();
//     super.onLoad();
//   }

//   Sprite _spriteForLives(int lives) {
//     if (lives <= 0) return _life0;
//     if (lives == 1) return _life1;
//     if (lives == 2) return _life2;
//     return _life3;
//   }

//   void _layout() {
//     final vp = gameRef.size;

//     // Escala final
//     final double s = uiScale;

//     // Tamanhos FINAIS
//     final Vector2 panelSize = _snap(_panelBaseSize * s);
//     lifePanel
//       ..size = panelSize
//       ..sprite = _spriteForLives(gameRef.lives);
//     scorePanel.size = panelSize;

//     // Avatar
//     final double avatarH = panelSize.y * avatarHFactor;
//     avatar.size = _snap(Vector2.all(avatarH));

//     // POSIÇÕES RELATIVAS (dentro do HUD)
//     avatar.position = _snap(Vector2(0, (panelSize.y - avatarH) / 2));
//     lifeBack.position = _snap(Vector2(avatar.size.x + gapH, 0));
//     lifePanel.position = lifeBack.position.clone();

//     scoreBack.position =
//         _snap(Vector2(lifePanel.position.x, panelSize.y + gapV));
//     scorePanel.position = scoreBack.position.clone();

//     // Backplates
//     final double inset = plateInset * s;
//     lifeBack.size =
//         _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));
//     scoreBack.size =
//         _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));

//     // Ajuste do backplate
//     lifeBack.position = _snap(lifePanel.position + Vector2(inset, inset));
//     scoreBack.position = _snap(scorePanel.position + Vector2(inset, inset));

//     // Texto dentro do painel de score
//     final Vector2 scoreTextOffset = _snap(Vector2(66 * s, 20 * s));
//     scoreText
//       ..text = '${gameRef.score}'
//       ..position = _snap(scorePanel.position + scoreTextOffset);

//     // Tamanho do HUD baseado no conteúdo
//     final double hudWidth = avatar.size.x + gapH + panelSize.x;
//     final double hudHeight = panelSize.y + gapV + panelSize.y;
//     size = Vector2(hudWidth, hudHeight);

//     // Posiciona a imagem de status no centro da viewport
//     gameStatusImage.position = Vector2(vp.x / 2, vp.y / 2);
//   }

//   // Arredonda para evitar sub-pixel
//   Vector2 _snap(Vector2 v) => Vector2(v.x.roundToDouble(), v.y.roundToDouble());

//   @override
//   void onGameResize(Vector2 size) {
//     super.onGameResize(size);
//     _layout();
//   }

//   @override
//   void update(double dt) {
//     // Atualiza score e sprite das vidas
//     scoreText.text = '${gameRef.score}';
//     lifePanel.sprite = _spriteForLives(gameRef.lives);

//     // Controla a visibilidade com opacity
//     if (gameRef.isGameOver) {
//       gameStatusImage
//         ..sprite = _gameOverSprite
//         ..priority = 1000
//         ..opacity = 1.0; // Totalmente visível
//         //ajuste de tempo da mensagem :
//         Future.delayed(Duration(seconds: 3), () {
//           hideStatusMessage();
//         });

//     } else if (gameRef.isGameWon) {
//       gameStatusImage
//         ..sprite = _gameWonSprite
//         ..priority = 1000
//         ..opacity = 1.0; // Totalmente visível
//         //ajuste de tempo da mensagem :
//         Future.delayed(Duration(seconds: 3), () {
//           hideStatusMessage();
//         });
//     } else {
//       gameStatusImage.opacity = 0.0; // Totalmente invisível
//     }
//     super.update(dt);
//   }

//   void hideStatusMessage() {
//     gameStatusImage.opacity = 0.0;
//   }
// }

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class HUD extends PositionComponent with HasGameRef<PixelAdventure> {
  // ===== Configuração ESTÁTICA =====
  static const double uiScale = 0.70;
  static const double marginLeft = 36;
  static const double marginTop = 28;
  static const double safeBleed = 10;
  static const double gapH = 10;
  static const double gapV = 8;
  static const double avatarHFactor = 0.95;

  // Backplate (fundo) atrás dos painéis
  static const Color plateColor = Color(0xFF2A2140);
  static const double plateInset = 4;

  // ===== Componentes =====
  late final SpriteComponent avatar;
  late final SpriteComponent lifePanel;
  late final SpriteComponent scorePanel;

  late final RectangleComponent lifeBack;
  late final RectangleComponent scoreBack;

  late final TextComponent scoreText;

  // Sprites
  late Sprite _life3, _life2, _life1, _life0;
  late Sprite _scoreSprite;
  late Sprite _gameOverSprite;
  late Sprite _gameWonSprite;

  // Tamanho real do PNG do painel
  late Vector2 _panelBaseSize;

  // **CONTROLE para evitar mostrar múltiplas vezes**
  bool _hasShownGameOver = false;
  bool _hasShownGameWon = false;

  @override
  Future<void> onLoad() async {
    priority = 1000;

    anchor = Anchor.topLeft;
    position = Vector2(marginLeft + safeBleed, marginTop + safeBleed);

    _scoreSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
    _panelBaseSize = _scoreSprite.srcSize.clone();

    // Sprites de vidas
    _life3 = await gameRef.loadSprite('Other/Dust Particle.png');
    _life2 = await gameRef.loadSprite('Other/Shadow.png');
    _life1 = await gameRef.loadSprite('Other/Transition.png');
    _life0 = await gameRef.loadSprite('Other/Shadow.png');

    _gameOverSprite = await gameRef.loadSprite('Other/Confetti (16x16).png');
    _gameWonSprite = await gameRef.loadSprite('Other/Shadow.png');

    // Componentes principais
    lifePanel = SpriteComponent(sprite: _life3, anchor: Anchor.topLeft)
      ..paint.filterQuality = FilterQuality.none;

    scorePanel = SpriteComponent(sprite: _scoreSprite, anchor: Anchor.topLeft)
      ..paint.filterQuality = FilterQuality.none;

    avatar = SpriteComponent(
      sprite: await gameRef.loadSprite('Main Characters/Ninja Frog/Idle (32x32).png'),
      anchor: Anchor.topLeft,
    )..paint.filterQuality = FilterQuality.none;

    // Backplates
    lifeBack = RectangleComponent(
        anchor: Anchor.topLeft, paint: Paint()..color = plateColor);
    scoreBack = RectangleComponent(
        anchor: Anchor.topLeft, paint: Paint()..color = plateColor);

    // Texto do score
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: GoogleFonts.vt323(
          textStyle: const TextStyle(
            fontSize: 28,
            color: Color(0xFFFFF1C4),
            shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
          ),
        ),
      ),
    );

    addAll([avatar, lifeBack, lifePanel, scoreBack, scorePanel, scoreText]);

    _layout();
    super.onLoad();
  }

  Sprite _spriteForLives(int lives) {
    if (lives <= 0) return _life0;
    if (lives == 1) return _life1;
    if (lives == 2) return _life2;
    return _life3;
  }

  void _layout() {
    final vp = gameRef.camera.viewport.size;

    final double s = uiScale;

    final Vector2 panelSize = _snap(_panelBaseSize * s);
    lifePanel
      ..size = panelSize
      ..sprite = _spriteForLives(gameRef.lives);
    scorePanel.size = panelSize;

    final double avatarH = panelSize.y * avatarHFactor;
    avatar.size = _snap(Vector2.all(avatarH));

    avatar.position = _snap(Vector2(0, (panelSize.y - avatarH) / 2));
    lifeBack.position = _snap(Vector2(avatar.size.x + gapH, 0));
    lifePanel.position = lifeBack.position.clone();

    scoreBack.position =
        _snap(Vector2(lifePanel.position.x, panelSize.y + gapV));
    scorePanel.position = scoreBack.position.clone();

    final double inset = plateInset * s;
    lifeBack.size =
        _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));
    scoreBack.size =
        _snap(Vector2(panelSize.x - inset * 2, panelSize.y - inset * 2));

    lifeBack.position = _snap(lifePanel.position + Vector2(inset, inset));
    scoreBack.position = _snap(scorePanel.position + Vector2(inset, inset));

    final Vector2 scoreTextOffset = _snap(Vector2(66 * s, 20 * s));
    scoreText
      ..text = '${gameRef.score}'
      ..position = _snap(scorePanel.position + scoreTextOffset);

    final double hudWidth = avatar.size.x + gapH + panelSize.x;
    final double hudHeight = panelSize.y + gapV + panelSize.y;
    size = Vector2(hudWidth, hudHeight);
  }

  Vector2 _snap(Vector2 v) => Vector2(v.x.roundToDouble(), v.y.roundToDouble());

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layout();
  }

  @override
  void update(double dt) {
    scoreText.text = '${gameRef.score}';
    lifePanel.sprite = _spriteForLives(gameRef.lives);

    if (gameRef.isGameOver && !_hasShownGameOver) {
      _showGameOverlay(_gameOverSprite);
      _hasShownGameOver = true;
    } else if (gameRef.isGameWon && !_hasShownGameWon) {
      _showGameOverlay(_gameWonSprite);
      _hasShownGameWon = true;
    }

    // Reseta os controles quando o jogo não está mais em estado final
    if (!gameRef.isGameOver && !gameRef.isGameWon) {
      _hasShownGameOver = false;
      _hasShownGameWon = false;
    }

    super.update(dt);
  }

  void _showGameOverlay(Sprite sprite) {
    // Cria um componente overlay com prioridade MÁXIMA
    final overlay = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.center,
      size: Vector2(300, 150),
      priority: 100000, 
    )..position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);

    // Adiciona diretamente ao jogo (não à câmera/viewport)
    gameRef.add(overlay);

    // Remove após 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      if (overlay.parent != null) {
        overlay.removeFromParent();
      }
    });
  }

  void hideStatusMessage() {
    // Não precisa mais deste método
  }
}
