// Importa os pacotes necessários
import 'dart:async'; // Para operações assíncronas

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/hud.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

// Classe principal do jogo que herda de FlameGame
// O "with" adiciona mixins (funcionalidades extras) ao jogo:
class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents, // Permite controle por teclado
        DragCallbacks, // Reconhece arrastar na tela
        HasCollisionDetection, // Detecta colisões entre objetos
        TapCallbacks {
  // Reconhece toques na tela

  // Define a cor de fundo do jogo (azul escuro)
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  // Componente de câmera que segue o jogador
  late CameraComponent cam;

  late HUD hud; // Componente HUD (Heads-Up Display)

  // Cria o jogador com o personagem 'Mask Dude'
  Player player = Player(character: 'Ninja Frog');

  // Joystick para controle em dispositivos móveis
  late JoystickComponent joystick;

  // Controla se mostra os controles na tela
  bool showControls = false;

  // Configurações de áudio
  bool playSounds = true;
  double soundVolume = 1.0;

  // Pontuação do jogador
  int score = 0;

  // Número de vidas do jogador
  int lives = 3;

  int liveEnemy = 3; // Número de vidas do inimigo

  bool isGameOver = false; // Indica se o jogo acabou

  bool isGameWon = false; // Indica se o jogo foi vencido

  // Lista com os nomes dos níveis do jogo
  List<String> levelNames = ['Level-01', 'Level-03', 'Level-07'];
  int currentLevelIndex = 0; // Índice do nível atual

  bool isLoadingLevel = false; // Indica se um nível está sendo carregado
  Level? currentLevel;

  // Método chamado quando o jogo é carregado
  @override
  FutureOr<void> onLoad() async {
    // Carrega todas as imagens do jogo na memória (cache), para reduzir o tempo de
    // carregamento
    await images.loadAllImages();

    // Carrega o nível inicial
    _loadLevel();

    // Se os controles estiverem ativados, adiciona joystick e botão de pulo
    if (showControls) {
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  // Método chamado a cada frame do jogo (atualização contínua)
  @override
  void update(double dt) {
    // dt = delta time (tempo desde o último frame)
    // Se os controles estiverem ativos, atualiza o joystick
    if (showControls) {
      updateJoystick();
    }

    checkGameStatus(); // Verifica o status do jogo
    super.update(dt); // Chama o método update da superclasse
  }

  // Método para adicionar o joystick na tela
  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10, // Prioridade de renderização (número maior = na frente)
      knob: SpriteComponent(
        // Parte móvel do joystick
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'), // Carrega imagem do knob
        ),
      ),
      background: SpriteComponent(
        // Base do joystick
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'), // Carrega imagem da base
        ),
      ),
      margin: const EdgeInsets.only(
          left: 32, bottom: 32), // Posição na tela, em pixels
    );

    add(joystick); // Adiciona o joystick ao jogo
  }

  // Atualiza o movimento do jogador baseado no joystick
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1; // Move para esquerda
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1; // Move para direita
        break;
      default:
        player.horizontalMovement = 0; // Para o movimento
        break;
    }
  }

  // Adiciona pontos à pontuação do jogador
  void addScore(int points) {
    score += points; // Adiciona os pontos

    if (score < 0) {
      score = 0; // Garante que a pontuação não fique negativa
    }
  }

  void loseLife() {
    if (lives > 0 && !isGameOver) {
      lives -= 1; 
    }

    if (lives <= 0) {
      lives = 0; 
      isGameOver = true;

      //checkGameStatus();

      _showGameOver();
    }
  }

  void _showGameOver() async {
    await Future.delayed(const Duration(seconds: 3));

    resetGame();
  }

  void loseLifeEnemy() {
    if (liveEnemy > 0) {
      liveEnemy -= 1; // Remove uma vida
    }

    if (liveEnemy < 0) {
      liveEnemy = 0; // Garante que as vidas não fiquem negativas
    }
  }

  // Verifica o status do jogo (game over ou vitória)
  void checkGameStatus() {
    if (lives <= 0 && !isGameOver) {
      isGameOver = true;
      _showGameOver();
    }
  }

  // Carrega o próximo nível do jogo
  // Método otimizado para carregar próximo nível
  void loadNextLevel() {
    // Prevenir múltiplos carregamentos simultâneos
    if (isLoadingLevel) return;

    isLoadingLevel = true;

    isGameWon = false;
    isGameOver = false;

    // Verifica se há mais níveis
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++; // Vai para o próximo nível
      _loadLevelWithCleanup();
    } else {
      // Se não houver mais níveis, marca vitória e reinicia
      if (!isGameWon) {
        isGameWon = true;
        hud.showGameOverlay(hud.gameWonSprite);
      }
      // Opcional: reiniciar o jogo ou voltar ao primeiro nível
      currentLevelIndex = 0;
      _loadLevelWithCleanup();
    }
  }

// Método melhorado para carregar nível com tratamento de erro
  void _loadLevelWithCleanup() {
    // Limpa componentes antigos de forma segura
    _cleanupCurrentLevel();

    // Pequeno delay para garantir que a limpeza foi concluída
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        _loadNewLevel();
      } catch (e) {
        _revertToCurrentLevel();
      }
    });
  }

// Limpeza segura dos componentes atuais
  void _cleanupCurrentLevel() {
    // Remove o nível atual se existir
    if (currentLevel != null && currentLevel!.parent != null) {
      remove(currentLevel!);
      currentLevel = null;
    }

    // Remove a câmera se existir
    if (cam.parent != null) {
      remove(cam);
    }
  }

// Carrega novo nível
  void _loadNewLevel() {
    // Cria novo mundo/nível
    Level newWorld = Level(
      player: player,
      levelName: levelNames[currentLevelIndex],
    );

    currentLevel = newWorld;

    if (levelNames[currentLevelIndex] == 'Level-01') {
      cam = CameraComponent.withFixedResolution(
        world: newWorld,
        width: 640,
        height: 368,
      );
    } else {
      cam = CameraComponent.withFixedResolution(
        world: newWorld,
        width: 480,
        height: 320,
      );
    }

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, newWorld]);

    hud = HUD();
    cam.viewport.add(hud);

    isLoadingLevel = false;
  }

// Reverte para o nível atual em caso de erro
  void _revertToCurrentLevel() {
    if (currentLevelIndex > 0) {
      currentLevelIndex--;
    }

    // Tenta carregar o nível atual novamente
    _loadNewLevel();
  }

// Método para recarregar o nível atual (útil para quando o jogador morre)
  void reloadCurrentLevel() {
    if (isLoadingLevel) return;

    isLoadingLevel = true;

    isGameOver = false;
    isGameWon = false;

    _loadLevelWithCleanup();
  }

  void resetGame() {
    // Reseta variáveis do jogo
    score = 0;
    lives = 3;
    liveEnemy = 3;
    isGameOver = false;
    isGameWon = false;
    currentLevelIndex = 0;

    if (currentLevel != null) {
      currentLevel!.removeFromParent();
      currentLevel = null;
    }
    if (cam.parent != null) {
      cam.removeFromParent();
    }

    // Carrega o nível inicial novamente
    _loadLevel();
  }

  // Método privado para carregar um nível
  void _loadLevel() {
    // Adiciona um pequeno delay antes de carregar o nível
    Future.delayed(const Duration(milliseconds: 100), () {
      // Cria o mundo/nível com o jogador e nome do nível
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      currentLevel = world;

      // Configuração condicional da câmera baseada no nível
      if (levelNames[currentLevelIndex] == 'Level-01') {
        // Configuração para Level-01 (mapa 40x23)
        cam = CameraComponent.withFixedResolution(
          world: world,
          width: 640, // 40 tiles * 16px = 640
          height: 368, // 23 tiles * 16px = 368
        );
      } else {
        // Configuração padrão para outros níveis (mapa 30x20)
        cam = CameraComponent.withFixedResolution(
          world: world,
          width: 480, // 30 tiles * 16px = 480
          height: 320, // 20 tiles * 16px = 320
        );
      }

      // cam = CameraComponent(
      //   world: world,
      // ); //camera pega a tela inteira

      cam.viewfinder.anchor =
          Anchor.topLeft; // Âncora no canto superior esquerdo

      // cam.viewport = MaxViewport(); // Usa toda a tela do dispositivo

      // Adiciona a câmera e o mundo ao jogo
      addAll([cam, world]);

      // hud = HUD();
      // cam.viewport.add(hud);

      isLoadingLevel = false;
    });
  }
}

/*
* Mixins: 
São como "superpoderes" que adicionamos à classe. Cada with adiciona uma funcionalidade 
específica. 
*late: 
Indica que a variável será inicializada depois, mas o Dart confia que vamos fazer isso 
antes de usar.
*async/await: 
Permite que o jogo carregue recursos (imagens) sem travar.
*CameraComponent: 
É como os "olhos" do jogador, que segue o personagem pelo nível.
*JoystickDirection: 
São as 8 direções possíveis de um joystick (como os pontos cardeais).
*Future.delayed: 
Cria um pequeno atraso antes de executar uma ação.
*/
