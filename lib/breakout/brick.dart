

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'ball.dart';
import 'breakout_game.dart';

class Brick extends RectangleComponent with HasGameRef<BreakoutGame>, CollisionCallbacks {
  Brick({
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()
            ..color = Colors.red
            ..style = PaintingStyle.fill,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final hitbox = RectangleHitbox();
    add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball) {
      game.increaseScore(20);
      other.velocity.y = -other.velocity.y;
      FlameAudio.play('breakout/brick.wav');
      removeFromParent();
    }
  }
}