import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'asteroids_game.dart';
import 'bullet.dart';
import 'ship.dart';

class Asteroid extends PositionComponent with CollisionCallbacks, HasGameRef<AsteroidsGame> {
  final double _speed = 100;
  final Vector2 _velocity;
  final double _rotationSpeed;

  Asteroid({required Vector2 position, required Vector2 velocity})
      : _velocity = velocity,
        _rotationSpeed = Random().nextDouble() * 2 - 1,
        super(
          position: position,
          size: Vector2.all(50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final shape = CircleHitbox();
    add(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * _speed * dt;
    angle += _rotationSpeed * dt;

    if (position.x < -size.x / 2) {
      position.x = game.size.x + size.x / 2;
    }
    if (position.x > game.size.x + size.x / 2) {
      position.x = -size.x / 2;
    }
    if (position.y < -size.y / 2) {
      position.y = game.size.y + size.y / 2;
    }
    if (position.y > game.size.y + size.y / 2) {
      position.y = -size.y / 2;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bullet) {
      removeFromParent();
      game.increaseScore();
    } else if (other is Ship) {
      removeFromParent();
      game.gameOver();
    }
  }
}