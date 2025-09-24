import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'asteroid.dart';
import 'asteroids_game.dart';

class Ship extends PositionComponent with CollisionCallbacks, HasGameRef<AsteroidsGame> {
  Vector2 velocity = Vector2.zero();
  double rotationSpeed = 3;

  Ship({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    size = Vector2(30, 40);
    anchor = Anchor.center;
    add(PolygonHitbox([
      Vector2(0, -size.y / 2),
      Vector2(-size.x / 2, size.y / 2),
      Vector2(size.x / 2, size.y / 2),
    ]));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y)
      ..lineTo(size.x / 2, size.y * 0.8)
      ..lineTo(0, size.y)
      ..close();
    canvas.drawPath(path, paint);
  }

  void turnLeft(double dt) {
    angle -= rotationSpeed * dt;
  }

  void turnRight(double dt) {
    angle += rotationSpeed * dt;
  }

  void thrust() {
    final radians = angle - math.pi / 2;
    final acceleration = Vector2(math.cos(radians), math.sin(radians)) * 2;
    velocity += acceleration;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Asteroid) {
      game.gameOver();
    }
  }
}