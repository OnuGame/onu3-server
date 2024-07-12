import 'package:onu3_server/onu/game_mode/classic_game_mode.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/onu/game_mode/special_game_mode.dart';

class GameModeRegistry {
  static List<GameMode> gameModes = [
    ClassicGameMode(),
    SpecialGameMode(),
  ];

  static GameMode? getGameMode(String name) {
    return gameModes.firstWhere((element) => element.name == name);
  }
}
