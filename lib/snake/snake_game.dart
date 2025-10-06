import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../asteroids/button.dart'; // Import the common Button component

class SnakeGame extends FlameGame with KeyboardHandler, HasCollisionDetection {
  static const int gridSize = 20;
  static int gridWidth = 38;
  static int gridHeight = 25;

  late SnakePlayer player;
  late Food food;
  late TextComponent scoreText;
  TextComponent? gameOverText;
  TextComponent? winText;
  TextComponent? restartText;

  int score = 0;
  double updateInterval = 0.2;
  late TimerComponent gameLoop;
  bool isGameRunning = true;
  bool _buttonsAdded = false;
  bool isLoaded = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
    add(scoreText);

    gameLoop = TimerComponent(
      period: updateInterval,
      repeat: true,
      onTick: () => updateGame(),
    );
    add(gameLoop);

    initializeGame();
    isLoaded = true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    gridWidth = (size.x / gridSize).floor();
    gridHeight = (size.y / gridSize).floor() - 2; // 2 grid bottom for buttons

    if (isLoaded) {
      if (isGameRunning) {
        initializeGame();
      }
      scoreText.position = Vector2(gridSize.toDouble(), gridSize.toDouble());
    }

    if (!_buttonsAdded) {
      addControlButtons(size);
      _buttonsAdded = true;
    }
    // Re-position text if it exists
    gameOverText?.position = size / 2;
    winText?.position = size / 2;
    restartText?.position = size / 2 + Vector2(0, 50);
  }

  void addControlButtons(Vector2 size) {
    double buttonSize = 60;
    double buttonSpacing = 20;
    Vector2 bottomCenter = Vector2(size.x / 2, size.y - 50);

    void handleButtonPress(Vector2 direction) {
      if (!isGameRunning) {
        initializeGame();
      } else {
        player.setDirection(direction);
      }
    }

    add(Button(
      label: 'Up',
      position: bottomCenter + Vector2(-buttonSize / 2, -buttonSize - buttonSpacing),
      size: Vector2(buttonSize, buttonSize),
      onPressed: () => handleButtonPress(Vector2(0, -1)),
      onReleased: () {},
    ));
    add(Button(
      label: 'Down',
      position: bottomCenter + Vector2(-buttonSize / 2, 0),
      size: Vector2(buttonSize, buttonSize),
      onPressed: () => handleButtonPress(Vector2(0, 1)),
      onReleased: () {},
    ));
    add(Button(
      label: 'Left',
      position: bottomCenter + Vector2(-buttonSize * 1.5 - buttonSpacing, -buttonSize/2 - buttonSpacing/2),
      size: Vector2(buttonSize, buttonSize),
      onPressed: () => handleButtonPress(Vector2(-1, 0)),
      onReleased: () {},
    ));
    add(Button(
      label: 'Right',
      position: bottomCenter + Vector2(buttonSize / 2 + buttonSpacing, -buttonSize/2 - buttonSpacing/2),
      size: Vector2(buttonSize, buttonSize),
      onPressed: () => handleButtonPress(Vector2(1, 0)),
      onReleased: () {},
    ));
  }

  void initializeGame() {
    score = 0;
    updateInterval = 0.4;
    gameLoop.timer.limit = updateInterval;
    isGameRunning = true;

    children.whereType<SnakePlayer>().forEach(remove);
    children.whereType<Food>().forEach(remove);
    
    gameOverText?.removeFromParent();
    winText?.removeFromParent();
    restartText?.removeFromParent();

    player = SnakePlayer();
    add(player);

    food = Food();
    food.randomizePosition(player.body);
    scoreText.text = 'Score: $score';
    gameLoop.timer.start();
  }

  void endGame({bool won = false}) {
    isGameRunning = false;
    gameLoop.timer.stop();

    if (won) {
      winText = TextComponent(
        text: 'YOU WIN!',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(style: const TextStyle(color: Colors.green, fontSize: 48)),
      );
      add(winText!);
    } else {
      gameOverText = TextComponent(
        text: 'GAME OVER',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(style: const TextStyle(color: Colors.red, fontSize: 48)),
      );
      add(gameOverText!);
    }

    restartText = TextComponent(
      text: 'Tap or press SPACE to Restart',
      position: size / 2 + Vector2(0, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
    add(restartText!);
  }

  void updateGame() {
    if (!isGameRunning) return;

    if (player.updatePosition()) {
      if (player.getHeadPosition() == food.gridPosition) {
        score += 10;
        player.grow();
        scoreText.text = 'Score: $score';

        if (player.body.length >= gridWidth * gridHeight) {
          endGame(won: true);
        } else {
          remove(food);
          food = Food();
          food.randomizePosition(player.body);
          add(food);

          updateInterval = max(0.1, 0.4 - (score / 1000));
          gameLoop.timer.limit = updateInterval;
        }
      }
    } else {
      endGame(won: false);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (!isGameRunning) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          initializeGame();
        }
        return true;
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        player.setDirection(Vector2(0, -1));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        player.setDirection(Vector2(0, 1));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        player.setDirection(Vector2(-1, 0));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        player.setDirection(Vector2(1, 0));
      }
    }
    return true;
  }
}

class SnakePlayer extends PositionComponent {
  late List<Vector2> body;
  Vector2 direction = Vector2(1, 0);
  final Paint paint = Paint()..color = Colors.green;
  final Paint headPaint = Paint()..color = Colors.teal;
  bool _isGrowing = false;

  SnakePlayer() {
    body = [Vector2(10, 10)];
  }

  void setDirection(Vector2 newDirection) {
    if (direction + newDirection != Vector2.zero()) {
      direction = newDirection;
    }
  }

  Vector2 getHeadPosition() {
    return body.first;
  }

  bool updatePosition() {
    final newHead = body.first + direction;

    if (newHead.x < 0 || newHead.x >= SnakeGame.gridWidth || newHead.y < 0 || newHead.y >= SnakeGame.gridHeight) {
      return false;
    }

    // Check for self-collision, excluding the tail
    final bodyWithoutTail = body.length > 1 ? body.sublist(0, body.length - 1) : [];
    if (bodyWithoutTail.contains(newHead)) {
      return false;
    }

    body.insert(0, newHead);

    if (_isGrowing) {
      _isGrowing = false;
    } else {
      body.removeLast();
    }
    
    return true;
  }

  void grow() {
    _isGrowing = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (var i = 0; i < body.length; i++) {
      final rect = Rect.fromLTWH(
        body[i].x * SnakeGame.gridSize,
        body[i].y * SnakeGame.gridSize,
        SnakeGame.gridSize.toDouble(),
        SnakeGame.gridSize.toDouble(),
      );
      canvas.drawRect(rect, i == 0 ? headPaint : paint);
    }
  }
}

class Food extends PositionComponent {
  final Paint paint = Paint()..color = Colors.red;
  final Random _random = Random();
  late Vector2 gridPosition;

  Food() {
    size = Vector2.all(SnakeGame.gridSize.toDouble());
  }

  void randomizePosition(List<Vector2> snakeBody) {
    do {
      gridPosition = Vector2(
        _random.nextInt(SnakeGame.gridWidth).toDouble(),
        _random.nextInt(SnakeGame.gridHeight).toDouble(),
      );
    } while (snakeBody.contains(gridPosition));
    position = gridPosition * SnakeGame.gridSize.toDouble();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), paint);
  }
}
