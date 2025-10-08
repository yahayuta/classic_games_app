import 'package:classic_games_app/asteroids/asteroids_game.dart' as game;
import 'package:classic_games_app/pong/pong_game.dart' as pongGame;
import 'package:classic_games_app/tetris/main.dart' as tetrisGame;
import 'package:classic_games_app/breakout/breakout_game.dart' as breakoutGame;
import 'package:classic_games_app/space_invaders/space_invaders.dart' as spaceInvadersGame;
import 'package:classic_games_app/missile_command/missile_command.dart' as missileCommandGame;
import 'package:classic_games_app/snake/snake_game.dart' as snakeGame;
import 'package:classic_games_app/blackjack/blackjack_game.dart' as blackjackGame;
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
          GameCard(
            title: 'Breakout',
            description: 'Destroy all the bricks.',
            icon: const Icon(Icons.view_carousel, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BreakoutGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Space Invaders',
            description: 'Defend the earth from alien invaders.',
            icon: const Icon(Icons.airplanemode_active, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpaceInvadersGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Missile Command',
            description: 'Defend your cities from incoming missiles!',
            icon: const Icon(Icons.shield, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MissileCommandGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Snake',
            description: 'Eat the food and grow.',
            icon: const Icon(Icons.turn_right, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SnakeGameScreen()),
              );
            },
          ),
          GameCard(
            title: 'Blackjack',
            description: 'Get as close to 21 as possible.',
            icon: const Icon(Icons.monetization_on, size: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlackjackGameScreen()),
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
        child: SingleChildScrollView(
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

class BreakoutGameScreen extends StatefulWidget {
  const BreakoutGameScreen({super.key});

  @override
  State<BreakoutGameScreen> createState() => _BreakoutGameScreenState();
}

class _BreakoutGameScreenState extends State<BreakoutGameScreen> {
  late final FocusNode _focusNode;
  late final breakoutGame.BreakoutGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = breakoutGame.BreakoutGame();
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
        title: const Text('Breakout'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class SpaceInvadersGameScreen extends StatefulWidget {
  const SpaceInvadersGameScreen({super.key});

  @override
  State<SpaceInvadersGameScreen> createState() => _SpaceInvadersGameScreenState();
}

class _SpaceInvadersGameScreenState extends State<SpaceInvadersGameScreen> {
  late final FocusNode _focusNode;
  late final spaceInvadersGame.SpaceInvadersGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = spaceInvadersGame.SpaceInvadersGame();
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
        title: const Text('Space Invaders'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class MissileCommandGameScreen extends StatefulWidget {
  const MissileCommandGameScreen({super.key});

  @override
  State<MissileCommandGameScreen> createState() => _MissileCommandGameScreenState();
}

class _MissileCommandGameScreenState extends State<MissileCommandGameScreen> {
  late final FocusNode _focusNode;
  late final missileCommandGame.MissileCommandGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = missileCommandGame.MissileCommandGame();
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
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late final FocusNode _focusNode;
  late final snakeGame.SnakeGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = snakeGame.SnakeGame();
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
        title: const Text('Snake'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}

class BlackjackGameScreen extends StatefulWidget {
  const BlackjackGameScreen({super.key});

  @override
  State<BlackjackGameScreen> createState() => _BlackjackGameScreenState();
}

class _BlackjackGameScreenState extends State<BlackjackGameScreen> {
  late final FocusNode _focusNode;
  late final blackjackGame.BlackjackGame _game;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _game = blackjackGame.BlackjackGame();
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
        title: const Text('Blackjack'),
      ),
      body: GameWidget(
        game: _game,
        focusNode: _focusNode,
      ),
    );
  }
}
