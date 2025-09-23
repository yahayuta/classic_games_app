import 'package:classic_games_app/asteroids/asteroids_game.dart' as game;
import 'package:classic_games_app/pong/pong_game.dart' as pongGame;
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
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Asteroids'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AsteroidsGameScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Pong'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PongGameScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AsteroidsGameScreen extends StatelessWidget {
  const AsteroidsGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroids'),
      ),
      body: GameWidget(game: game.AsteroidsGame()),
    );
  }
}

class PongGameScreen extends StatelessWidget {
  const PongGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pong'),
      ),
      body: GameWidget(game: pongGame.PongGame()),
    );
  }
}
