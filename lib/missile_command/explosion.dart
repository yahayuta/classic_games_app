import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Explosion extends PositionComponent with CollisionCallbacks {
  static final _paint = Paint()..color = const Color(0xFFFFFFFF);
  double _radius = 1;
  bool _maxed = false;
  double _timer = 0;

  double get radius => _radius;

  late CircleHitbox hitbox;

  Explosion({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    hitbox = CircleHitbox(radius: _radius);
    await add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, _radius, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_maxed) {
      _radius += 3;
      hitbox.radius = _radius;
      if (_radius >= 60) {
        _radius = 60;
        hitbox.radius = _radius;
        _maxed = true;
      }
    } else {
      _timer += dt;
      if (_timer >= 1) {
        removeFromParent();
      }
    }
  }
}
