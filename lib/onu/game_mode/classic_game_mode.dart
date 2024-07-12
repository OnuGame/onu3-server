import 'package:onu3_server/onu/card.dart';
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
  List<Setting> get settings => [
        ...super.settings,
      ];

  @override
  bool cardPlaced(Game game, Card card) {
    throw UnimplementedError();
  }

  @override
  Card generateCard() {
    throw UnimplementedError();
  }
}
