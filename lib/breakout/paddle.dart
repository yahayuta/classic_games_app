
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Paddle extends RectangleComponent with HasGameRef, CollisionCallbacks {
  Paddle({
    required this.dragging,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xffffffff)
            ..style = PaintingStyle.fill,
        );

  bool dragging;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final hitbox = RectangleHitbox();
    add(hitbox);
  }

  void move(Vector2 delta) {
    position.add(delta);
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
  }
}