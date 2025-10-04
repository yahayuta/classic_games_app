import 'dart:ui';

import 'package:flame/components.dart';

import 'package:flame/text.dart';

class MissileBase extends PositionComponent {
  static final _paint = Paint()..color = const Color(0xFFFFFFFF);
  static final _selectedPaint = Paint()..color = const Color(0xFF00FF00); // Green for selected
  bool isDestroyed = false;
  int ammo;
  late TextPaint _textPaint;
  bool isSelected;

  MissileBase({required Vector2 position, this.ammo = 10, this.isSelected = false}) : super(position: position, size: Vector2(30, 20)) {
    _textPaint = TextPaint(style: const TextStyle(fontSize: 10, color: Color(0xFFFFFFFF)));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!isDestroyed) {
      canvas.drawRect(size.toRect(), isSelected ? _selectedPaint : _paint);
      _textPaint.render(canvas, ammo.toString(), Vector2(size.x / 2, size.y), anchor: Anchor.topCenter);
    }
  }

  void destroy() {
    isDestroyed = true;
    ammo = 0;
  }

  bool fire() {
    if (ammo > 0) {
      ammo--;
      return true;
    }
    return false;
  }
}
