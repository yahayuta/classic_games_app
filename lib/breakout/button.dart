
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Button extends PositionComponent with TapCallbacks {
  Button({
    required this.label,
    required super.position,
    required super.size,
  });

  final String label;
  bool isPressed = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final text = TextComponent(
      text: label,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(text);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = isPressed ? const Color(0x88ffffff) : const Color(0x44ffffff)
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isPressed = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    isPressed = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isPressed = false;
  }
}
