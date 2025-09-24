
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'asteroid.dart';
import 'asteroids_game.dart';

class Bullet extends PositionComponent with CollisionCallbacks, HasGameRef<AsteroidsGame> {
  final Vector2 velocity;
  static const double _speed = 500;

  Bullet({
    required Vector2 position,
    required double angle,
  }) : velocity = Vector2(math.cos(angle - math.pi / 2), math.sin(angle - math.pi / 2)) * _speed,
       super(position: position, angle: angle);

  @override
  Future<void> onLoad() async {
    size = Vector2(4, 4);
    anchor = Anchor.center;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Asteroid) {
      removeFromParent();
    }
  }
}
