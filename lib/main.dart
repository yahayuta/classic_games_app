
import 'package:classic_games_app/asteroids/asteroids_game.dart' as game;
import 'package:classic_games_app/pong/pong_game.dart' as pongGame;
import 'package:classic_games_app/tetris/main.dart' as tetrisGame;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classic Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.pressStart2pTextTheme(),
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic Games'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          GameCard(
            title: 'Asteroids',
            description: 'Shoot asteroids and survive!',
            icon: const Icon(Icons.public, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AsteroidsGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Pong',
            description: 'The classic table tennis game.',
            icon: const Icon(Icons.sports_tennis, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PongGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Tetris',
            description: 'Fit the falling blocks.',
            icon: const Icon(Icons.view_module, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TetrisGameScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget icon;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class AsteroidsGameScreen extends StatefulWidget {
  const AsteroidsGameScreen({super.key});

  @override
  State<AsteroidsGameScreen> createState() => _AsteroidsGameScreenState();
}

class _AsteroidsGameScreenState extends State<AsteroidsGameScreen> {
  late final FocusNode _focusNode;
  late final game.AsteroidsGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = game.AsteroidsGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroids'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class PongGameScreen extends StatefulWidget {
  const PongGameScreen({super.key});

  @override
  State<PongGameScreen> createState() => _PongGameScreenState();
}

class _PongGameScreenState extends State<PongGameScreen> {
  late final FocusNode _focusNode;
  late final pongGame.PongGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = pongGame.PongGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pong'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class TetrisGameScreen extends StatefulWidget {
  const TetrisGameScreen({super.key});

  @override
  State<TetrisGameScreen> createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends State<TetrisGameScreen> {
  late final FocusNode _focusNode;
  late final tetrisGame.TetrisGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = tetrisGame.TetrisGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}
