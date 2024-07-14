import 'dart:math';

import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/card_preset.dart';
import 'package:onu3_server/onu/card_template.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/setting.dart';
import 'package:onu3_server/packet/outgoing/update_deck_packet.dart';

abstract class GameMode {
  String get name;
  String get description;

  List<CardPreset> get cardPresets;
  List<CardTemplate> get cardTemplates => cardPresets
      .expand(
        (preset) => preset.generateCardTemplates(),
      )
      .toList();

  List<String> get colors => cardTemplates.map((e) => e.color).toSet().toList()
    ..sort((a, b) => a.compareTo(b));

  List<String> get types => cardTemplates.map((e) => e.type).toSet().toList()
    ..sort((a, b) => a.compareTo(b));

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
      player.send(UpdateDeckPacket(deck: deck));
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

    // sort deck by card color and type
    deck.sort((a, b) {
      if (a.color == b.color) {
        return a.type.compareTo(b.type);
      }
      return a.color.compareTo(b.color);
    });

    return deck;
  }

  bool compareCards(Card a, Card b);

  Card generateCard() {
    var rng = Random();
    return cardTemplates[rng.nextInt(cardTemplates.length)].create();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "settings": settings,
      "colors": colors,
      "types": types,
      "templates": cardTemplates,
    };
  }
}
