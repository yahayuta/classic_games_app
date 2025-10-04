import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:classic_games_app/missile_command/explosion.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:classic_games_app/missile_command/missile_command_game.dart';

import 'package:classic_games_app/missile_command/missile_base.dart';

import 'package:classic_games_app/missile_command/city.dart';

class EnemyMissile extends PositionComponent with HasGameRef<MissileCommandGame>, CollisionCallbacks {
  static final _paint = Paint()..color = const Color(0xFFFF0000);
  late Vector2 velocity;

  EnemyMissile({
    required Vector2 position,
    required Vector2 target,
  }) : super(position: position) {
    final direction = target - position;
    velocity = direction.normalized() * 50;
  }

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawLine(position.toOffset(), (position - velocity * 0.1).toOffset(), _paint..strokeWidth = 8);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Explosion) {
      gameRef.increaseScore();
      removeFromParent();
    }
  }
}
