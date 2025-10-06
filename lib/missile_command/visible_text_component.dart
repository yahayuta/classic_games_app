import 'package:flame/components.dart';

class VisibleTextComponent extends TextComponent with HasVisibility {
  VisibleTextComponent({
    super.text,
    super.position,
    super.textRenderer,
    super.anchor,
  });
}
