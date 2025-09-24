
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import 'asteroid.dart';
import 'button.dart';
import 'bullet.dart';
import 'ship.dart';

class AsteroidsGame extends FlameGame with KeyboardHandler, HasCollisionDetection {
  late Ship _ship;
  final double _shootCooldown = 0.5;
  double _timeSinceLastShot = 0.0;
  int _score = 0;
  late TextComponent _scoreText;
  bool isGameOver = false;

  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  bool _isThrustPressed = false;
  bool _isFirePressed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _ship = Ship(position: size / 2);
    add(_ship);

    // Add asteroids
    for (int i = 0; i < 5; i++) {
      add(Asteroid(
        position: Vector2(
          Random().nextDouble() * size.x,
          Random().nextDouble() * size.y,
        ),
        velocity: Vector2.random(Random()) - Vector2.random(Random()),
      ));
    }

    _scoreText = TextComponent(
      text: 'Score: $_score',
      position: Vector2(10, 10),
    );
    add(_scoreText);

    // Add buttons
    add(Button(
      label: 'Left',
      position: Vector2(50, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isLeftPressed = true,
      onReleased: () => _isLeftPressed = false,
    ));

    add(Button(
      label: 'Right',
      position: Vector2(150, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isRightPressed = true,
      onReleased: () => _isRightPressed = false,
    ));

    add(Button(
      label: 'Thrust',
      position: Vector2(size.x - 230, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isThrustPressed = true,
      onReleased: () => _isThrustPressed = false,
    ));

    add(Button(
      label: 'Fire',
      position: Vector2(size.x - 130, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isFirePressed = true,
      onReleased: () => _isFirePressed = false,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _timeSinceLastShot += dt;

    if (_isLeftPressed) {
      _ship.turnLeft(dt);
    }
    if (_isRightPressed) {
      _ship.turnRight(dt);
    }
    if (_isThrustPressed) {
      _ship.thrust();
    }
    if (_isFirePressed) {
      if (_timeSinceLastShot >= _shootCooldown) {
        final bullet = Bullet(
          position: _ship.position.clone(),
          angle: _ship.angle,
        );
        add(bullet);
        _timeSinceLastShot = 0.0;
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (isGameOver) return false;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _ship.turnLeft(0.016);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _ship.turnRight(0.016);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _ship.thrust();
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (_timeSinceLastShot >= _shootCooldown) {
        final bullet = Bullet(
          position: _ship.position.clone(),
          angle: _ship.angle,
        );
        add(bullet);
        _timeSinceLastShot = 0.0;
      }
    }
    return true;
  }

  void increaseScore() {
    _score++;
    _scoreText.text = 'Score: $_score';
  }

  void gameOver() {
    isGameOver = true;
    final gameOverText = TextComponent(
      text: 'Game Over',
      position: size / 2,
      anchor: Anchor.center,
    );
    add(gameOverText);
  }
}
