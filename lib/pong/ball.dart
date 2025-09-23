
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends PositionComponent {
  static const double ballRadius = 10;
  Vector2 velocity;

  Ball({required Vector2 position, required this.velocity})
      : super(
          position: position,
          size: Vector2.all(ballRadius * 2),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    canvas.drawCircle(size.toRect().center, ballRadius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
