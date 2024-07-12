import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';

class SpecialGameMode extends GameMode {
  @override
  String get name => "Special";

  @override
  String get description =>
      "The special game mode introduces new cards such as 'Redistribute' and 'Swap' and new colors such as 'Cyan' and 'Purple'. Cyan can be place on any blue or green card, and purple can be placed on any blue or red card.";

  @override
  bool cardPlaced(Game game, Card card) {
    throw UnimplementedError();
  }

  @override
  Card generateCard() {
    throw UnimplementedError();
  }
}
