
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Button extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  final VoidCallback onReleased;
  final String label;

  late TextComponent _textComponent;
  late RectangleComponent _background;

  static final Paint _backgroundPaint = Paint()..color = const Color(0xFF8B0000); // Dark Red
  static final Paint _pressedPaint = Paint()..color = const Color(0xFFB22222); // Firebrick

  Button({
    required this.onPressed,
    required this.onReleased,
    required this.label,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _background = RectangleComponent(
      size: size,
      paint: _backgroundPaint,
    );
    add(_background);

    _textComponent = TextComponent(
      text: label,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
    add(_textComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _background.paint = _pressedPaint;
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _background.paint = _backgroundPaint;
    onReleased();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _background.paint = _backgroundPaint;
    onReleased();
  }
}
