import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends PositionComponent {
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
    canvas.drawRect(size.toRect(), paint);
  }
}
