
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ball.dart';
import 'brick.dart';
import 'button.dart';
import 'paddle.dart';

enum GameState {
  playing,
  gameOver,
}

class BreakoutGame extends FlameGame
    with HasCollisionDetection, KeyboardHandler, TapCallbacks {
  var gameState = GameState.playing;
  int score = 0;
  int lives = 3;
  int level = 1;
  double ballSpeedMultiplier = 1.0;

  bool _isInitialized = false;
  final math.Random _random = math.Random();

  late TextComponent _scoreText;
  late TextComponent _livesText;
  late TextComponent _levelText;
  TextComponent? _gameOverText;

  late Button _leftButton;
  late Button _rightButton;

  bool _isLeftKeyPressed = false;
  bool _isRightKeyPressed = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await FlameAudio.audioCache.loadAll([
      'breakout/bgm.wav',
      'breakout/brick.wav',
      'breakout/gameover.wav',
      'breakout/levelup.wav',
      'breakout/paddle.wav',
      'breakout/wall.wav',
    ]);
  }

  void initializeGame() {
    FlameAudio.loop('breakout/bgm.wav');

    add(ScreenHitbox());

    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(10, 10),
    );
    add(_scoreText);

    _livesText = TextComponent(
      text: 'Lives: $lives',
      position: Vector2(size.x - 70, 10),
    );
    add(_livesText);

    _levelText = TextComponent(
      text: 'Level: $level',
      position: Vector2(size.x / 2, 10),
      anchor: Anchor.topCenter,
    );
    add(_levelText);

    _leftButton = Button(
      label: 'Left',
      position: Vector2(20, size.y - 60),
      size: Vector2(80, 40),
    );
    add(_leftButton);

    _rightButton = Button(
      label: 'Right',
      position: Vector2(size.x - 100, size.y - 60),
      size: Vector2(80, 40),
    );
    add(_rightButton);

    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!_isInitialized && size.x > 0 && size.y > 0) {
      initializeGame();
      _isInitialized = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameState == GameState.playing) {
      if (children.whereType<Brick>().isEmpty) {
        nextLevel();
      }

      final paddles = children.whereType<Paddle>();
      if (paddles.isNotEmpty) {
        final paddle = paddles.first;
        final paddleSpeed = 500.0;
        if (_leftButton.isPressed || _isLeftKeyPressed) {
          paddle.move(Vector2(-paddleSpeed * dt, 0));
        }
        if (_rightButton.isPressed || _isRightKeyPressed) {
          paddle.move(Vector2(paddleSpeed * dt, 0));
        }
      }
    }
  }

  void resetGame() {
    score = 0;
    lives = 3;
    level = 1;
    ballSpeedMultiplier = 1.0;
    _scoreText.text = 'Score: $score';
    _livesText.text = 'Lives: $lives';
    _levelText.text = 'Level: $level';
    gameState = GameState.playing;

    children.whereType<Paddle>().forEach((element) => element.removeFromParent());
    children.whereType<Ball>().forEach((element) => element.removeFromParent());
    children.whereType<Brick>().forEach((element) => element.removeFromParent());
    _gameOverText?.removeFromParent();

    final paddle = Paddle(
      dragging: false,
      position: Vector2(size.x / 2, size.y * 0.9),
      size: Vector2(size.x * 0.3, size.y * 0.05),
    );
    add(paddle);

    resetBall();
    createBricks();
  }

  void resetBall() {
    children.whereType<Ball>().forEach((element) => element.removeFromParent());
    final randomXPosition = size.x * (_random.nextDouble() * 0.6 + 0.2);
    final randomXVelocity = (_random.nextDouble() - 0.5) * 150;

    final ball = Ball(
      velocity: Vector2(randomXVelocity, -size.y * 0.3) * ballSpeedMultiplier,
      position: Vector2(randomXPosition, size.y * 0.8),
      radius: size.x * 0.02,
    );
    add(ball);
  }

  void createBricks() {
    int rows = 4 + level;
    const columns = 5;
    final brickSize = Vector2(size.x * 0.15, size.y * 0.05);
    const brickPadding = 5.0;
    final totalBricksWidth = (columns * brickSize.x) + ((columns - 1) * brickPadding);
    final offsetX = (size.x - totalBricksWidth) / 2;
    final offsetY = size.y * 0.1;

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        final brick = Brick(
          position: Vector2(
            offsetX + j * (brickSize.x + brickPadding) + brickSize.x / 2,
            offsetY + i * (brickSize.y + brickPadding) + brickSize.y / 2,
          ),
          size: brickSize,
        );
        add(brick);
      }
    }
  }

  void nextLevel() {
    level++;
    ballSpeedMultiplier *= 1.15;
    _levelText.text = 'Level: $level';
    FlameAudio.play('breakout/levelup.wav');
    resetBall();
    createBricks();
  }

  void loseLife() {
    lives--;
    _livesText.text = 'Lives: $lives';
    if (lives <= 0) {
      gameOver();
    } else {
      resetBall();
    }
  }

  void gameOver() {
    FlameAudio.play('breakout/gameover.wav');
    gameState = GameState.gameOver;
    _gameOverText = TextComponent(
      text: 'Game Over\nPress any key to restart',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      position: size / 2,
      anchor: Anchor.center,
    );
    add(_gameOverText!);
    pauseEngine();
  }

  void increaseScore(int amount) {
    score += amount;
    _scoreText.text = 'Score: $score';
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (gameState == GameState.playing) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _isLeftKeyPressed = event is KeyDownEvent;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _isRightKeyPressed = event is KeyDownEvent;
      }
    } else if (gameState == GameState.gameOver && event is KeyDownEvent) {
      resetGame();
      resumeEngine();
    }
    return true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (gameState == GameState.gameOver) {
      resetGame();
      resumeEngine();
    }
  }
}
