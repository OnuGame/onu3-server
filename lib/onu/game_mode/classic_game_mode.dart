import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/card_preset.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/onu/setting.dart';

class ClassicGameMode extends GameMode {
  @override
  String get name => "Classic";

  @override
  String get description =>
      "The classic game mode is the original game mode with the original cards and colors.";

  @override
  List<CardPreset> get cardPresets => [
        CardPreset(
          colors: ["r", "g", "b", "y"],
          types: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
          datas: [],
        ),
        CardPreset(
          colors: [""],
          types: ["w"],
          datas: [
            {'cardAmount': 0},
            {'cardAmount': 4},
          ],
        ),
        CardPreset(
          colors: ["r", "g", "b", "y"],
          types: ["p"],
          datas: [
            {'cardAmount': 2},
          ],
        )
      ];

  @override
  List<Setting> get settings => [
        ...super.settings,
      ];

  @override
  bool compareCards(Card a, Card b) {
    // TODO - check if this is correct
    return (a.color == "" || b.color == "") ||
        (a.color == b.color || a.type == b.type);
  }

  @override
  bool cardPlaced(Game game, Card card) {
    if (game.stack.isEmpty) return true;
    return compareCards(game.stack.last, card);
  }
}
