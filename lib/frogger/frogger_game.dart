import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'button.dart';

class FroggerGame extends FlameGame with HasCollisionDetection, KeyboardHandler {
  late Player player;
  late List<Enemy> enemies;
  late TextComponent scoreText;
  int score = 0;
  late Timer enemySpawner;
  bool isGameOver = false;

  bool _isUpPressed = false;
  bool _isDownPressed = false;
  bool _isLeftPressed = false;
  bool _isRightPressed = false;

  @override
  Future<void> onLoad() async {

    await super.onLoad();

    player = Player();
    add(player);

    enemies = [];

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
    );
    add(scoreText);

    enemySpawner = Timer(1.0, onTick: spawnEnemy, repeat: true);
    enemySpawner.start();

    // Add buttons
    add(Button(
      label: 'Up',
      position: Vector2(size.x / 2 - 40, size.y - 150),
      size: Vector2(80, 40),
      onPressed: () => _isUpPressed = true,
      onReleased: () => _isUpPressed = false,
    ));

    add(Button(
      label: 'Down',
      position: Vector2(size.x / 2 - 40, size.y - 50),
      size: Vector2(80, 40),
      onPressed: () => _isDownPressed = true,
      onReleased: () => _isDownPressed = false,
    ));

    add(Button(
      label: 'Left',
      position: Vector2(size.x / 2 - 130, size.y - 100),
      size: Vector2(80, 40),
      onPressed: () => _isLeftPressed = true,
      onReleased: () => _isLeftPressed = false,
    ));

    add(Button(
      label: 'Right',
      position: Vector2(size.x / 2 + 50, size.y - 100),
      size: Vector2(80, 40),
      onPressed: () => _isRightPressed = true,
      onReleased: () => _isRightPressed = false,
    ));
  }

  void spawnEnemy() {
    final random = Random();
    final y = (random.nextInt(5) + 1) * 80.0;
    final enemy = Enemy();
    enemy.position = Vector2(0, y);
    add(enemy);
    enemies.add(enemy);
  }

  @override
  void update(double dt) {

    if (!isGameOver) {
      enemySpawner.update(dt);

      if (_isUpPressed) {
        player.move(Vector2(0, -40));
        _isUpPressed = false;
      }
      if (_isDownPressed) {
        player.move(Vector2(0, 40));
        _isDownPressed = false;
      }
      if (_isLeftPressed) {
        player.move(Vector2(-40, 0));
        _isLeftPressed = false;
      }
      if (_isRightPressed) {
        player.move(Vector2(40, 0));
        _isRightPressed = false;
      }

      if (player.position.y < 0) {
        score += 10;
        scoreText.text = 'Score: $score';
        player.position = Vector2(size.x / 2, size.y - player.size.y);
      }
    }
    super.update(dt);
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    enemySpawner.stop();

    final gameOverText = TextComponent(
      text: 'Game Over',
      position: Vector2(size.x / 2, size.y / 2 - 50),
      anchor: Anchor.center,
    );
    add(gameOverText);

    add(Button(
      label: 'Restart',
      position: Vector2(size.x / 2 - 60, size.y / 2 + 20),
      size: Vector2(120, 40),
      onPressed: () => restart(),
      onReleased: () {},
    ));
  }

  void restart() {
    isGameOver = false;
    score = 0;
    scoreText.text = 'Score: $score';

    player.position = Vector2(size.x / 2, size.y - player.size.y);

    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
    enemies.clear();

    children.whereType<TextComponent>().where((c) => c.text == 'Game Over').forEach((c) => c.removeFromParent());
    children.whereType<Button>().where((c) => c.label == 'Restart').forEach((c) => c.removeFromParent());

    enemySpawner.start();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        player.move(Vector2(0, -40));
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        player.move(Vector2(0, 40));
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.move(Vector2(-40, 0));
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.move(Vector2(40, 0));
      }
    }
    return true;
  }
}

class Player extends SpriteComponent with HasGameRef<FroggerGame>, CollisionCallbacks {
  Player() : super(size: Vector2.all(40.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('frogger/player.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - size.y);
    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {

      gameRef.gameOver();
    }
  }
}

class Enemy extends SpriteComponent with HasGameRef<FroggerGame>, CollisionCallbacks {
  double speed = 100.0;

  Enemy() : super(size: Vector2.all(40.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('frogger/enemy.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!gameRef.isGameOver) {
      position.x += speed * dt;

      if (position.x > gameRef.size.x) {
        removeFromParent();
        gameRef.enemies.remove(this);
      }
    }
    super.update(dt);
  }
}