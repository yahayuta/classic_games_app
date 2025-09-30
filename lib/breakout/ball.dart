
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'breakout_game.dart';
import 'paddle.dart';

class Ball extends CircleComponent with HasGameRef<BreakoutGame>, CollisionCallbacks {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xffffffff)
            ..style = PaintingStyle.fill,
        );

  Vector2 velocity;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final hitbox = CircleHitbox();
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ScreenHitbox) {
      final collisionPoint = intersectionPoints.first;
      if (collisionPoint.x <= 0 || collisionPoint.x >= game.size.x) {
        velocity.x = -velocity.x;
        FlameAudio.play('breakout/wall.wav');
      }
      if (collisionPoint.y <= 0) {
        velocity.y = -velocity.y;
        FlameAudio.play('breakout/wall.wav');
      }
      if (collisionPoint.y >= game.size.y) {
        game.loseLife();
        removeFromParent();
      }
    } else if (other is Paddle) {
      velocity.y = -velocity.y;
      game.increaseScore(10);
      FlameAudio.play('breakout/paddle.wav');
    }
  }
}