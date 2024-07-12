import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game.dart';

abstract class GameMode {
  final String name;
  final String description;
  final Map<String, dynamic> options = {
    "deckSize": 7,
  };

  GameMode({
    required this.name,
    required this.description,
  });

  void startGame(Game game) {
    for (var player in game.players) {
      List<Card> deck = generateDeck(options['deckSize'] as int);
      player.deck.addAll(deck);
    }
  }

  bool cardPlaced(Game game, Card card);

  void endGame(Game game) {
    for (var player in game.players) {
      player.deck.clear();
    }
  }

  /// Create a deck of cards. This method is called for every player on game start.
  List<Card> generateDeck(int size) {
    if (size < 0) {
      throw ArgumentError("Deck size must be greater than 0");
    }

    List<Card> deck = [];
    for (int i = 0; i < size; i++) {
      deck.add(generateCard());
    }

    return deck;
  }

  Card generateCard();
}
