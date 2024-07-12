import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/setting.dart';

abstract class GameMode {
  String get name;
  String get description;
  List<Setting> get settings => [
        Setting(name: "Card Amount", defaultValue: 7),
      ];

  void startGame(Game game) {
    if (!game.settings.containsKey('Card Amount')) {
      print(
        "Card Amount setting is missing. Skipping player deck generation.",
      );
      return;
    }

    int cardAmount = game.settings['Card Amount'];

    for (var player in game.players) {
      List<Card> deck = generateDeck(cardAmount);
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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "settings": settings.map((setting) => setting.toJson()).toList(),
    };
  }
}
