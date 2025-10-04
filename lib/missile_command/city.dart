import 'dart:ui';

import 'package:flame/components.dart';

class City extends PositionComponent {
  static final _paint = Paint()..color = const Color(0xFF00C8FF);
  bool isDestroyed = false;

  City({required Vector2 position}) : super(position: position, size: Vector2(50, 30));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!isDestroyed) {
      canvas.drawRect(size.toRect(), _paint);
    }
  }

  void destroy() {
    isDestroyed = true;
  }
}
