import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';

import 'button.dart';

enum Suit { hearts, diamonds, clubs, spades }

enum Rank {
  ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
}

enum GameState { betting, playing, dealerTurn, playerBust, dealerBust, playerWin, dealerWin, tie }

class Card {
  final Suit suit;
  final Rank rank;

  Card(this.suit, this.rank);

  static const Map<Rank, String> _rankToString = {
    Rank.ace: 'ace',
    Rank.two: '2',
    Rank.three: '3',
    Rank.four: '4',
    Rank.five: '5',
    Rank.six: '6',
    Rank.seven: '7',
    Rank.eight: '8',
    Rank.nine: '9',
    Rank.ten: '10',
    Rank.jack: 'jack',
    Rank.queen: 'queen',
    Rank.king: 'king',
  };

  @override
  String toString() {
    return '${_rankToString[rank]}_of_${suit.name}';
  }
}

class Deck {
  final List<Card> _cards = [];

  Deck() {
    for (var suit in Suit.values) {
      for (var rank in Rank.values) {
        _cards.add(Card(suit, rank));
      }
    }
  }

  void shuffle() {
    _cards.shuffle(Random());
  }

  Card deal() {
    return _cards.removeLast();
  }
}

class BlackjackGame extends FlameGame with TapCallbacks {

  final Map<String, Sprite> _cardSprites = {};

  late Deck _deck;

  List<Card> playerHand = [];

  List<Card> dealerHand = [];

  GameState gameState = GameState.betting;



  late TextComponent gameStatusText;

  late Button _hitButton;

  late Button _standButton;

  late Button _newGameButton;

  bool _isInitialized = false;



  @override

  Future<void> onLoad() async {

    await super.onLoad();



    for (var suit in Suit.values) {

      for (var rank in Rank.values) {

        final card = Card(suit, rank);

        final sprite = await Sprite.load('blackjack/cards/${card.toString()}.png');

        _cardSprites[card.toString()] = sprite;

      }

    }

    final backSprite = await Sprite.load('blackjack/cards/back.png');

    _cardSprites['back'] = backSprite;

  }



  @override

  void onGameResize(Vector2 size) {

    super.onGameResize(size);

    if (!_isInitialized) {

      initializeGame();

      _isInitialized = true;

    }

  }



  void initializeGame() {

    if (isMounted) {

      children.whereType<Button>().forEach((button) => button.removeFromParent());

      children.whereType<TextComponent>().forEach((text) => text.removeFromParent());

      children.whereType<RectangleComponent>().forEach((rect) => rect.removeFromParent());

    }



    add(RectangleComponent(size: size, paint: Paint()..color = const Color(0xFF006400)));



    gameStatusText = TextComponent(

      text: '',

      position: Vector2(size.x / 2, 50),

      anchor: Anchor.topCenter,

      textRenderer: TextPaint(style: TextStyle(fontSize: 24, color: Colors.white)),

    );

    add(gameStatusText);



    _hitButton = Button(

      label: 'Hit',

      position: Vector2(size.x / 2 - 110, size.y - 60),

      size: Vector2(100, 40),

      onPressed: () {

        if (gameState == GameState.playing) {

          hit();

        }

      },

      onReleased: () {},

    );



    _standButton = Button(

      label: 'Stand',

      position: Vector2(size.x / 2 + 10, size.y - 60),

      size: Vector2(100, 40),

      onPressed: () {

        if (gameState == GameState.playing) {

          stand();

        }

      },

      onReleased: () {},

    );



    _newGameButton = Button(

      label: 'New Game',

      position: Vector2(size.x / 2 - 50, size.y - 60),

      size: Vector2(100, 40),

      onPressed: () {

        initializeGame();

      },

      onReleased: () {},

    );



    _deck = Deck();

    _deck.shuffle();

    playerHand.clear();

    dealerHand.clear();



    // Deal initial hands

    playerHand.add(_deck.deal());

    playerHand.add(_deck.deal());

    dealerHand.add(_deck.deal());

    dealerHand.add(_deck.deal());



    gameState = GameState.playing;



    add(_hitButton);

    add(_standButton);

  }



  void hit() {

    playerHand.add(_deck.deal());

    if (calculateHandValue(playerHand) > 21) {

      gameState = GameState.playerBust;

      _resolveGame();

    }

  }



  void stand() {

    gameState = GameState.dealerTurn;

    while (calculateHandValue(dealerHand) < 17) {

      dealerHand.add(_deck.deal());

    }

    _resolveGame();

  }



  int calculateHandValue(List<Card> hand) {

    int value = 0;

    int aceCount = 0;

    for (var card in hand) {

      switch (card.rank) {

        case Rank.ace:

          value += 11;

          aceCount++;

          break;

        case Rank.two: value += 2; break;

        case Rank.three: value += 3; break;

        case Rank.four: value += 4; break;

        case Rank.five: value += 5; break;

        case Rank.six: value += 6; break;

        case Rank.seven: value += 7; break;

        case Rank.eight: value += 8; break;

        case Rank.nine: value += 9; break;

        case Rank.ten:

        case Rank.jack:

        case Rank.queen:

        case Rank.king:

          value += 10;

          break;

      }

    }

    while (value > 21 && aceCount > 0) {

      value -= 10;

      aceCount--;

    }

    return value;

  }



  void _resolveGame() {

    if (gameState == GameState.playerBust) {

      // Player already busted

    } else {

      final playerValue = calculateHandValue(playerHand);

      final dealerValue = calculateHandValue(dealerHand);



      if (dealerValue > 21) {

        gameState = GameState.dealerBust;

      } else if (dealerValue > playerValue) {

        gameState = GameState.dealerWin;

      } else if (dealerValue < playerValue) {

        gameState = GameState.playerWin;

      } else {

        gameState = GameState.tie;

      }

    }



    _hitButton.removeFromParent();

    _standButton.removeFromParent();

    add(_newGameButton);

  }



  void _updateGameStatusText() {

    if (!isMounted) return;

    switch (gameState) {

      case GameState.playing:

        gameStatusText.text = 'Your turn';

        break;

      case GameState.playerBust:

        gameStatusText.text = 'You Busted!';

        break;

      case GameState.dealerTurn:

        gameStatusText.text = 'Dealer\'s turn';

        break;

      case GameState.playerWin:

        gameStatusText.text = 'You Win!';

        break;

      case GameState.dealerWin:

        gameStatusText.text = 'Dealer Wins!';

        break;

      case GameState.dealerBust:

        gameStatusText.text = 'Dealer Busted! You Win!';

        break;

      case GameState.tie:

        gameStatusText.text = 'Push (Tie)';

        break;

      default:

        gameStatusText.text = '';

    }

  }



  @override

  void update(double dt) {

    if (!_isInitialized) return;

    super.update(dt);

    _updateGameStatusText();

  }



  @override

  void render(Canvas canvas) {

    if (!_isInitialized) return;

    super.render(canvas);



    // Draw hands

    _drawHand(canvas, 'Player', playerHand, calculateHandValue(playerHand), Vector2(50, 300));

    _drawHand(canvas, 'Dealer', dealerHand, calculateHandValue(dealerHand), Vector2(50, 100), revealFirstCard: gameState != GameState.playing);

  }



  void _drawHand(Canvas canvas, String title, List<Card> hand, int value, Vector2 position, {bool revealFirstCard = true}) {

    // Draw title

    final textPainter = TextPainter(

      text: TextSpan(text: '$title Hand - Value: $value', style: TextStyle(fontSize: 18, color: Colors.white)),

      textDirection: TextDirection.ltr,

    );

    textPainter.layout();

    textPainter.paint(canvas, position.toOffset());



    // Draw cards

    for (var i = 0; i < hand.length; i++) {

      final card = hand[i];

      final cardSprite = (i == 0 && !revealFirstCard) ? _cardSprites['back'] : _cardSprites[card.toString()];

      if (cardSprite != null) {

        cardSprite.render(canvas, position: Vector2(position.x + i * 80, position.y + 30), size: Vector2(70, 100));

      }

    }

  }

}