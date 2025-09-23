
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Paddle extends PositionComponent {
  static const double speed = 200;
  static final Vector2 paddleSize = Vector2(20, 100);

  Paddle({required Vector2 position})
      : super(
          position: position,
          size: paddleSize,
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);
  }

  void moveUp(double dt) {
    position.y -= speed * dt;
  }

  void moveDown(double dt) {
    position.y += speed * dt;
  }
}
