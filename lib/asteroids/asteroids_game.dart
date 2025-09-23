import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'ship.dart';
import 'bullet.dart';

class Player extends Component {
  final ship = Ship();

  @override
  Future<void> onLoad() async {
    add(ship);
  }
}

class AsteroidsGame extends FlameGame with KeyboardHandler {
  final player = Player();
  Set<LogicalKeyboardKey> _keysPressed = {};
  final double _shootCooldown = 0.5;
  double _timeSinceLastShot = 0.0;

  @override
  Future<void> onLoad() async {
    await add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastShot += dt;

    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.ship.turnLeft(dt);
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.ship.turnRight(dt);
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      player.ship.thrust();
    }
    if (_keysPressed.contains(LogicalKeyboardKey.space)) {
      if (_timeSinceLastShot >= _shootCooldown) {
        final bullet = Bullet(
          position: player.ship.position.clone(),
          angle: player.ship.angle,
        );
        add(bullet);
        _timeSinceLastShot = 0.0;
      }
    }
  }

  @override
  bool onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _keysPressed = keysPressed;
    return true;
  }
}
