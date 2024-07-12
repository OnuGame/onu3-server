import 'package:onu3_server/onu/game.dart';

class GameManager {
  Map<String, Game> games = {};

  Game? getGame(String gameCode) {
    print(games);
    return games[gameCode];
  }

  Game createGame({
    required String gameCode,
    String password = "",
  }) {
    return games.putIfAbsent(
        gameCode, () => Game(gameCode: gameCode, password: password));
  }

  Game? removeGame(String gameCode) {
    Game? game = games[gameCode];
    if (game == null) {
      return null;
    }

    games.remove(gameCode);
    return game;
  }

  List<Game> getGames() {
    return games.values.toList();
  }
}
