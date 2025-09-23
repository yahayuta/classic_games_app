
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'ball.dart';
import 'paddle.dart';

class PongGame extends FlameGame with KeyboardHandler, HasCollisionDetection {
  late Paddle _player1;
  late Paddle _player2;
  late Ball _ball;

  final double _ballSpeed = 200;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _player1 = Paddle(position: Vector2(50, size.y / 2));
    _player2 = Paddle(position: Vector2(size.x - 50, size.y / 2));
    _ball = Ball(
      position: size / 2,
      velocity: Vector2.random(Random()) * _ballSpeed,
    );

    add(_player1);
    add(_player2);
    add(_ball);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      _player1.moveUp(0.016);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _player1.moveDown(0.016);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _player2.moveUp(0.016);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _player2.moveDown(0.016);
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_ball.position.y <= 0 || _ball.position.y >= size.y) {
      _ball.velocity.y = -_ball.velocity.y;
    }

    if (_ball.position.x <= 0 || _ball.position.x >= size.x) {
      _ball.position = size / 2;
      _ball.velocity = Vector2.random(Random()) * _ballSpeed;
    }

    // Simple collision detection
    if (_ball.toRect().overlaps(_player1.toRect()) ||
        _ball.toRect().overlaps(_player2.toRect())) {
      _ball.velocity.x = -_ball.velocity.x;
    }
  }
}
