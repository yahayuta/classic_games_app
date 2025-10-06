import 'dart:math';

import 'package:classic_games_app/missile_command/city.dart';
import 'package:classic_games_app/missile_command/enemy_missile.dart';
import 'package:classic_games_app/missile_command/explosion.dart';
import 'package:classic_games_app/missile_command/missile_base.dart';
import 'package:classic_games_app/missile_command/player_missile.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';

import 'package:flutter/services.dart';

import 'package:classic_games_app/missile_command/visible_text_component.dart';

class MissileCommandGame extends FlameGame with HasCollisionDetection, TapCallbacks, KeyboardEvents {
  late Timer _missileSpawnTimer;
  final List<City> _cities = [];
  int score = 0;
  late final TextComponent _scoreText = TextComponent(text: 'Score: $score', position: Vector2(10, 10));
  late final TextComponent _waveText = TextComponent(text: 'Wave: 1', position: Vector2(10, 70));
  late final TextComponent _highScoreText = TextComponent(text: 'High Score: 0', position: Vector2(size.x - 150, 10));
  bool _isGameOver = false;
  int _currentWave = 1;
  final int _highScore = 0;

  late MissileBase _missileBase;

  late final VisibleTextComponent _gameOverText = VisibleTextComponent(
    text: 'GAME OVER',
    position: size / 2,
    anchor: Anchor.center,
    textRenderer: TextPaint(style: const TextStyle(fontSize: 48, color: Color(0xFFFF0000))),
  )..isVisible = false;
  late final VisibleTextComponent _restartText = VisibleTextComponent(
    text: 'Tap to Restart',
    position: Vector2(size.x / 2, size.y / 2 + 50),
    anchor: Anchor.center,
    textRenderer: TextPaint(style: const TextStyle(fontSize: 24, color: Color(0xFFFFFFFF))),
  )..isVisible = false;

  @override
  Future<void> onLoad() async {
    add(_scoreText);
    add(_waveText);
    add(_highScoreText);
    add(_gameOverText);
    add(_restartText);
    resetGame(); // Initialize game state on load
  }

  void resetGame() {
    // Clear all existing components
    removeAll(children.where((component) => component is! TextComponent && component is! VisibleTextComponent));

    _cities.clear();
    score = 0;
    _currentWave = 1;
    _isGameOver = false;

    // Screen dimensions
    final screenWidth = size.x;
    final screenHeight = size.y;

    // City settings
    const cityWidth = 50.0;
    const numCities = 6;
    const citySpacing = (800 - numCities * cityWidth) / (numCities + 1);

    // Add cities
    for (var i = 0; i < numCities; i++) {
      final x = citySpacing + i * (cityWidth + citySpacing);
      final y = screenHeight - 30 - 10;
      final city = City(position: Vector2(x, y));
      add(city);
      _cities.add(city);
    }

    // Add single missile base
    _missileBase = MissileBase(position: Vector2(screenWidth / 2, screenHeight - 20), ammo: 999, isSelected: true);
    add(_missileBase);

    // Score text
    _scoreText.text = 'Score: $score';

    // Wave text
    _waveText.text = 'Wave: $_currentWave';

    // High Score text
    _highScoreText.text = 'High Score: $_highScore';


    // Game Over text (initially hidden)
    _gameOverText.isVisible = false;

    _restartText.isVisible = false;

    // Start missile spawn timer
    _missileSpawnTimer = Timer(2, onTick: _spawnEnemyMissile, repeat: true);
    _missileSpawnTimer.start();
  }

  void _spawnEnemyMissile() {
    if (_isGameOver) return;
    final random = Random();
    final startX = random.nextDouble() * size.x;
    final targetCity = _cities.where((city) => !city.isDestroyed).toList();
    if (targetCity.isEmpty) return;
    final target = targetCity[random.nextInt(targetCity.length)];
    add(EnemyMissile(position: Vector2(startX, 0), target: target.position));
  }

  void increaseScore() {
    score += 100;
    _scoreText.text = 'Score: $score';
  }

  void advanceWave() {
    _currentWave++;
    _waveText.text = 'Wave: $_currentWave';
    // Stop the current timer and create a new one with reduced interval
    _missileSpawnTimer.stop();
    _missileSpawnTimer = Timer(max(0.5, _missileSpawnTimer.limit - 0.2), onTick: _spawnEnemyMissile, repeat: true);
    _missileSpawnTimer.start();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_isGameOver) {
      resetGame();
      return;
    }
    if (!_missileBase.isDestroyed) {
      add(PlayerMissile(position: _missileBase.position, target: event.localPosition));
    }
  }



  @override
  void update(double dt) {
    super.update(dt);
    if (_isGameOver) return;

    _missileSpawnTimer.update(dt);

    // Check for wave advancement (if no enemy missiles are left)
    if (children.whereType<EnemyMissile>().isEmpty && !_missileSpawnTimer.isRunning()) {
      advanceWave();
    }

    if (_cities.every((city) => city.isDestroyed)) {
      _isGameOver = true;
      _gameOverText.isVisible = true;
      _restartText.isVisible = true;
      _missileSpawnTimer.stop(); // Stop spawning missiles
    }
  }
}
