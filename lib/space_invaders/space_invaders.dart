
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../asteroids/button.dart';

class SpaceInvadersGame extends FlameGame with HasCollisionDetection, KeyboardHandler {
  late Player _player;
  final List<Enemy> _enemies = [];
  final List<Bullet> _bullets = [];
  final List<EnemyBullet> _enemyBullets = [];
  int _score = 0;
  int _stage = 1;
  late TextComponent _scoreText;
  late TextComponent _stageText;
  double _timeSinceLastShot = 0.0;
  final double _shootCooldown = 0.5;

  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  bool _isFirePressed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player(position: Vector2(size.x / 2, size.y - 100));
    add(_player);
    _spawnEnemies();

    _scoreText = TextComponent(
      text: 'Score: $_score',
      position: Vector2(20, 20),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );
    add(_scoreText);

    _stageText = TextComponent(
      text: 'Stage: $_stage',
      position: Vector2(20, 50),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );
    add(_stageText);

    add(Button(
      label: 'Left',
      position: Vector2(50, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isLeftPressed = true,
      onReleased: () => _isLeftPressed = false,
    ));

    add(Button(
      label: 'Right',
      position: Vector2(150, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isRightPressed = true,
      onReleased: () => _isRightPressed = false,
    ));

    add(Button(
      label: 'Fire',
      position: Vector2(size.x - 130, size.y - 60),
      size: Vector2(80, 40),
      onPressed: () => _isFirePressed = true,
      onReleased: () => _isFirePressed = false,
    ));
  }

  void _spawnEnemies() {
    final random = Random();
    for (int i = 0; i < 8 + _stage * 2; i++) {
      final enemy = Enemy(
        position: Vector2(
          random.nextDouble() * size.x,
          random.nextDouble() * (size.y / 2),
        ),
        speed: 100.0 + _stage * 10,
      );
      _enemies.add(enemy);
      add(enemy);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastShot += dt;

    if (_isLeftPressed) {
      _player.position.x -= 200 * dt;
    }
    if (_isRightPressed) {
      _player.position.x += 200 * dt;
    }
    if (_isFirePressed) {
      if (_timeSinceLastShot >= _shootCooldown) {
        final bullet = Bullet(
          position: _player.position.clone(),
        );
        _bullets.add(bullet);
        add(bullet);
        _timeSinceLastShot = 0.0;
      }
    }

    for (final bullet in _bullets) {
      bullet.position.y -= 500 * dt;
      if (bullet.position.y < 0) {
        remove(bullet);
      }
    }

    for (final enemy in _enemies) {
      enemy.position.x += enemy.direction * enemy.speed * dt;
      if (enemy.position.x < 0 || enemy.position.x > size.x - enemy.size.x) {
        enemy.direction *= -1;
      }

      if (Random().nextDouble() < 0.001) {
        final enemyBullet = EnemyBullet(
          position: enemy.position.clone(),
        );
        _enemyBullets.add(enemyBullet);
        add(enemyBullet);
      }
    }

    for (final enemyBullet in _enemyBullets) {
      enemyBullet.position.y += 250 * dt;
      if (enemyBullet.position.y > size.y) {
        remove(enemyBullet);
      }
    }

    // Check collisions
    final bulletsToRemove = <Bullet>[];
    final enemiesToRemove = <Enemy>[];
    final enemyBulletsToRemove = <EnemyBullet>[];

    for (final bullet in _bullets) {
      for (final enemy in _enemies) {
        if (bullet.toRect().overlaps(enemy.toRect())) {
          bulletsToRemove.add(bullet);
          enemiesToRemove.add(enemy);
          _score += 10;
          _scoreText.text = 'Score: $_score';
        }
      }
    }

    for (final enemyBullet in _enemyBullets) {
      if (_player.toRect().overlaps(enemyBullet.toRect())) {
        enemyBulletsToRemove.add(enemyBullet);
        pauseEngine();
        break;
      }
    }

    for (final bullet in bulletsToRemove) {
      _bullets.remove(bullet);
      remove(bullet);
    }

    for (final enemy in enemiesToRemove) {
      _enemies.remove(enemy);
      remove(enemy);
    }

    for (final enemyBullet in enemyBulletsToRemove) {
      _enemyBullets.remove(enemyBullet);
      remove(enemyBullet);
    }

    if (_enemies.isEmpty) {
      _stage++;
      _stageText.text = 'Stage: $_stage';
      _spawnEnemies();
    }

    _bullets.removeWhere((bullet) => bullet.position.y < 0);
    _enemyBullets.removeWhere((bullet) => bullet.position.y > size.y);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _isLeftPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    _isRightPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    _isFirePressed = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }
  
  @override
  Color backgroundColor() => Colors.black;
}

class Player extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  Player({required Vector2 position}) : super(position: position, size: Vector2(50, 50));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}

class Enemy extends PositionComponent {
  double speed;
  int direction = 1;
  static final _paint = Paint()..color = Colors.green;

  Enemy({required Vector2 position, this.speed = 100}) : super(position: position, size: Vector2(40, 40));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}

class Bullet extends PositionComponent {
  static final _paint = Paint()..color = Colors.red;

  Bullet({required Vector2 position}) : super(position: position, size: Vector2(5, 10));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}

class EnemyBullet extends PositionComponent {
  static final _paint = Paint()..color = Colors.yellow;

  EnemyBullet({required Vector2 position}) : super(position: position, size: Vector2(5, 10));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }
}
