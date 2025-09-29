import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:flame_audio/flame_audio.dart';
import './button.dart';

// Game constants
const int boardWidth = 10;
const int boardHeight = 20;
const double blockSize = 30.0;

// Colors
final Color backgroundColor = Colors.grey[850]!;
final Color gridColor = Colors.grey[700]!;

// Tetromino colors
final List<Color> tetrominoColors = [
  Colors.cyan,      // I
  Colors.purple,    // T
  Colors.red,       // Z
  Colors.green,     // S
  Colors.yellow,    // O
  Colors.orange,    // L
  Colors.blue,      // J
];

// Tetromino shapes
final List<List<List<int>>> tetrominoShapes = [
  [[1, 1, 1, 1]], // I
  [[0, 1, 0], [1, 1, 1]], // T
  [[1, 1, 0], [0, 1, 1]], // Z
  [[0, 1, 1], [1, 1, 0]], // S
  [[1, 1], [1, 1]], // O
  [[1, 0, 0], [1, 1, 1]], // L
  [[0, 0, 1], [1, 1, 1]], // J
];

class TetrisGame extends FlameGame with KeyboardHandler {
  late List<List<Color?>> gameBoard;
  late Tetromino currentPiece;
  late Tetromino nextPiece;
  double fallTimer = 0.0;
  double fallSpeed = 1.0; // seconds per fall
  int score = 0;
  int level = 1;
  int linesCleared = 0;
  bool isGameOver = false;
  Tetromino? heldPiece;
  bool canHold = true;
  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  bool _isUiLoaded = false;

  static const Map<int, int> scoreValues = {
    1: 100,
    2: 300,
    3: 500,
    4: 800,
  };

  late TextComponent scoreText;
  late TextComponent gameOverText;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await FlameAudio.audioCache.loadAll([
      'move.wav',
      'rotate.wav',
      'drop.wav',
      'line_clear.wav',
      'game_over.wav',
    ]);

    // Game World
    // camera.viewport = FixedResolutionViewport(resolution: Vector2(640, 960));


    final gameOverStyle = TextStyle(
      color: Colors.red,
      fontSize: 48,
      fontFamily: 'PressStart2P',
    );
    final gameOverRenderer = TextPaint(style: gameOverStyle);
    gameOverText = TextComponent(text: 'GAME OVER', textRenderer: gameOverRenderer)
      ..anchor = Anchor.center
      ..position = Vector2((boardWidth * blockSize) / 2, (boardHeight * blockSize) / 2);
    // add(gameOverText); // Initially removed

    initializeGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    print("onGameResize called with size: $size");

    if (!_isUiLoaded) {
      // Side Panel
      final panelX = boardWidth * blockSize + 10;
      final panelWidth = 280.0; // Increased panel width
      add(
        RectangleComponent(
          position: Vector2(panelX, 0),
          size: Vector2(panelWidth, size.y),
          paint: Paint()..color = Colors.black.withOpacity(0.5),
        )
      );

      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'PressStart2P',
      );
      final regular = TextPaint(style: textStyle);

      scoreText = TextComponent(text: 'Score: 0\nLevel: 1\nLines: 0', textRenderer: regular)
        ..anchor = Anchor.topCenter
        ..position = Vector2(panelX + panelWidth / 2, 50);
      add(scoreText);

      final holdText = TextComponent(text: 'Hold:', textRenderer: regular)
        ..anchor = Anchor.topCenter
        ..position = Vector2(panelX + panelWidth / 2, 150);
      add(holdText);

      final nextText = TextComponent(text: 'Next:', textRenderer: regular)
        ..anchor = Anchor.topCenter
        ..position = Vector2(panelX + panelWidth / 2, 250);
      add(nextText);

      // On-screen Controls
      final buttonSize = Vector2(80, 40);
      final buttonY = size.y - buttonSize.y - 20;

      // Left
      add(Button(
        label: '<-',
        size: buttonSize,
        position: Vector2(10, buttonY),
        onPressed: () => _isLeftPressed = true,
        onReleased: () => _isLeftPressed = false,
      ));

      // Right
      add(Button(
        label: '->',
        size: buttonSize,
        position: Vector2(100, buttonY),
        onPressed: () => _isRightPressed = true,
        onReleased: () => _isRightPressed = false,
      ));

      // Rotate
      add(Button(
        label: 'Rot',
        size: buttonSize,
        position: Vector2(size.x - 190, buttonY),
        onPressed: rotatePiece,
        onReleased: () {},
      ));

      // Hard Drop
      add(Button(
        label: 'Drop',
        size: buttonSize,
        position: Vector2(size.x - 100, buttonY),
        onPressed: hardDrop,
        onReleased: () {},
      ));

      _isUiLoaded = true;
    }
  }

  void initializeGame() {
    gameBoard = List.generate(boardHeight, (y) => List.generate(boardWidth, (x) => null));
    score = 0;
    level = 1;
    linesCleared = 0;
    isGameOver = false;
    if (gameOverText.isMounted) {
      remove(gameOverText);
    }
    heldPiece = null;
    canHold = true;

    // Initialize pieces
    currentPiece = _getRandomPiece();
    nextPiece = _getRandomPiece();
  }

  Tetromino _getRandomPiece() {
    final random = Random();
    final shapeIndex = random.nextInt(tetrominoShapes.length);
    return Tetromino(
      shape: tetrominoShapes[shapeIndex],
      color: tetrominoColors[shapeIndex],
      position: Vector2((boardWidth / 2).floor().toDouble() - 1, 0),
    );
  }

  void spawnNewPiece() {
    currentPiece = nextPiece;
    nextPiece = _getRandomPiece();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    scoreText.text = 'Score: $score\nLevel: $level\nLines: $linesCleared';

    if (_isLeftPressed) {
      movePiece(Vector2(-1, 0));
    }
    if (_isRightPressed) {
      movePiece(Vector2(1, 0));
    }

    fallTimer += dt;
    if (fallTimer >= fallSpeed) {
      fallTimer = 0;
      movePiece(Vector2(0, 1));
    }
  }

  @override
  bool onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (isGameOver) {
        if (keysPressed.contains(LogicalKeyboardKey.enter)) {
          initializeGame();
          return true;
        }
        return false;
      }

      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        movePiece(Vector2(-1, 0));
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        movePiece(Vector2(1, 0));
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        movePiece(Vector2(0, 1));
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        rotatePiece();
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyH)) {
        holdPiece();
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.space)) {
        hardDrop();
        return true;
      }
    }
    return false;
  }

  void hardDrop() {
    int dropDistance = 0;
    while (!checkCollision(currentPiece, Vector2(currentPiece.position.x, currentPiece.position.y + 1))) {
      currentPiece.position.y++;
      dropDistance++;
    }
    score += dropDistance * 2; // Add bonus for hard drop
    lockPiece();
    spawnNewPiece();
  }

  void holdPiece() {
    if (!canHold) return;

    if (heldPiece == null) {
      heldPiece = currentPiece;
      spawnNewPiece();
    } else {
      final temp = currentPiece;
      currentPiece = heldPiece!;
      heldPiece = temp;
      currentPiece.position = Vector2((boardWidth / 2).floor().toDouble() - 1, 0);
    }
    canHold = false;
    FlameAudio.play('move.wav');
  }

  void rotatePiece() {
    final originalShape = currentPiece.shape;
    currentPiece.rotate();
    if (checkCollision(currentPiece, currentPiece.position)) {
      // If collision, revert rotation
      currentPiece.shape = originalShape;
    } else {
      FlameAudio.play('rotate.wav');
    }
  }

  void movePiece(Vector2 direction) {
    if (!checkCollision(currentPiece, Vector2(currentPiece.position.x + direction.x, currentPiece.position.y + direction.y))) {
      currentPiece.move(direction);
      if (direction.x != 0) {
        FlameAudio.play('move.wav');
      }
    }
    else {
      if (direction.y > 0) {
        lockPiece();
        spawnNewPiece();
      }
    }
  }

  bool checkCollision(Tetromino piece, Vector2 newPosition) {
    for (var y = 0; y < piece.shape.length; y++) {
      for (var x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          final boardX = newPosition.x + x;
          final boardY = newPosition.y + y;

          // Check boundaries
          if (boardX < 0 || boardX >= boardWidth || boardY >= boardHeight) {
            return true;
          }
          // Check against locked pieces on the board
          if (boardY >= 0 && gameBoard[boardY.toInt()][boardX.toInt()] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void lockPiece() {
    for (var y = 0; y < currentPiece.shape.length; y++) {
      for (var x = 0; x < currentPiece.shape[y].length; x++) {
        if (currentPiece.shape[y][x] == 1) {
          final boardY = currentPiece.position.y + y;
          final boardX = currentPiece.position.x + x;
          if (boardY >= 0 && boardY < boardHeight && boardX >= 0 && boardX < boardWidth) {
            gameBoard[boardY.toInt()][boardX.toInt()] = currentPiece.color;
          }
        }
      }
    }
    canHold = true;
    FlameAudio.play('drop.wav');
    clearLines();
  }

  void clearLines() {
    int clearedInThisTurn = 0;
    for (var y = boardHeight - 1; y >= 0; y--) {
      if (gameBoard[y].every((cell) => cell != null)) {
        clearedInThisTurn++;
        // Line is full, remove it
        gameBoard.removeAt(y);
        // Add a new empty line at the top
        gameBoard.insert(0, List.generate(boardWidth, (x) => null));
        // Since we removed a line, we need to check the same y index again
        y++;
      }
    }
    if (clearedInThisTurn > 0) {
      linesCleared += clearedInThisTurn;
      score += (scoreValues[clearedInThisTurn] ?? 0) * level;
      level = (linesCleared / 10).floor() + 1;
      fallSpeed = max(0.1, 1.0 - (level - 1) * 0.05);
      FlameAudio.play('line_clear.wav');
    }
  }

  @override
  void render(Canvas canvas) {
    drawBackground(canvas);
    drawGameBoard(canvas);
    drawGhostPiece(canvas);
    drawTetromino(canvas, currentPiece);
    if (heldPiece != null) {
      drawSidePiece(canvas, heldPiece!, 200.0);
    }
    drawSidePiece(canvas, nextPiece, 300.0);
    super.render(canvas);
  }

  void drawGhostPiece(Canvas canvas) {
    if (isGameOver) return;

    var ghostPosition = Vector2(currentPiece.position.x, currentPiece.position.y);
    while (!checkCollision(currentPiece, Vector2(ghostPosition.x, ghostPosition.y + 1))) {
      ghostPosition.y++;
    }

    final piecePaint = Paint()..color = currentPiece.color.withOpacity(0.3);
    for (var y = 0; y < currentPiece.shape.length; y++) {
      for (var x = 0; x < currentPiece.shape[y].length; x++) {
        if (currentPiece.shape[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              (ghostPosition.x + x) * blockSize,
              (ghostPosition.y + y) * blockSize,
              blockSize,
              blockSize,
            ),
            piecePaint,
          );
        }
      }
    }
  }

  void drawSidePiece(Canvas canvas, Tetromino piece, double yOffset) {
    final piecePaint = Paint()..color = piece.color;
    final panelX = boardWidth * blockSize + 10;
    final panelWidth = 150.0;
    
    // Calculate the width of the piece in blocks
    final pieceWidthInBlocks = piece.shape[0].length;
    final pieceGraphicWidth = pieceWidthInBlocks * blockSize * 0.5;
    
    final sideX = panelX + (panelWidth / 2) - (pieceGraphicWidth / 2);

    for (var y = 0; y < piece.shape.length; y++) {
      for (var x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              sideX + x * blockSize * 0.5, // smaller blocks
              yOffset + y * blockSize * 0.5,
              blockSize * 0.5,
              blockSize * 0.5,
            ),
            piecePaint,
          );
        }
      }
    }
  }

  void drawBackground(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = backgroundColor);
  }

  void drawGameBoard(Canvas canvas) {
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw background for the board
    canvas.drawRect(Rect.fromLTWH(0, 0, boardWidth * blockSize, boardHeight * blockSize), Paint()..color = Colors.black);

    // Draw locked pieces
    for (var y = 0; y < boardHeight; y++) {
      for (var x = 0; x < boardWidth; x++) {
        if (gameBoard[y][x] != null) {
          canvas.drawRect(
            Rect.fromLTWH(x * blockSize, y * blockSize, blockSize, blockSize),
            Paint()..color = gameBoard[y][x]!,
          );
        }
      }
    }

    // Draw grid lines
    for (var x = 0; x <= boardWidth; x++) {
      canvas.drawLine(
        Offset(x * blockSize, 0),
        Offset(x * blockSize, boardHeight * blockSize),
        gridPaint,
      );
    }
    for (var y = 0; y <= boardHeight; y++) {
      canvas.drawLine(
        Offset(0, y * blockSize),
        Offset(boardWidth * blockSize, y * blockSize),
        gridPaint,
      );
    }
  }

  void drawTetromino(Canvas canvas, Tetromino piece) {
    final piecePaint = Paint()..color = piece.color;
    for (var y = 0; y < piece.shape.length; y++) {
      for (var x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              (piece.position.x + x) * blockSize,
              (piece.position.y + y) * blockSize,
              blockSize,
              blockSize,
            ),
            piecePaint,
          );
        }
      }
    }
  }
}

class Tetromino {
  List<List<int>> shape;
  Color color;
  Vector2 position;

  Tetromino({required this.shape, required this.color, required this.position});

  void move(Vector2 direction) {
    position += direction;
  }

  void rotate() {
    final newShape = List.generate(shape[0].length, (y) => List.generate(shape.length, (x) => 0));
    for (var y = 0; y < shape.length; y++) {
      for (var x = 0; x < shape[y].length; x++) {
        newShape[x][shape.length - 1 - y] = shape[y][x];
      }
    }
    shape = newShape;
  }
}