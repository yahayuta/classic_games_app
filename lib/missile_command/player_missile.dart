import 'dart:ui';

import 'package:classic_games_app/missile_command/explosion.dart';
import 'package:flame/components.dart';

class PlayerMissile extends PositionComponent with HasGameRef {
  static final _paint = Paint()..color = const Color(0xFFFFFF00);
  late Vector2 velocity;
  late Vector2 target;

  PlayerMissile({
    required Vector2 position,
    required this.target,
  }) : super(position: position) {
    final direction = target - position;
    velocity = direction.normalized() * 300;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawLine(position.toOffset(), (position - velocity * 0.05).toOffset(), _paint..strokeWidth = 8);
    canvas.drawCircle(position.toOffset(), 4, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if ((position - target).length < 5) {
      gameRef.add(Explosion(position: target));
      removeFromParent();
    }
  }
}
