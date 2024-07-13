import 'package:onu3_server/onu/game.dart';

class GameManager {
  static GameManager instance = GameManager();

  Map<String, Game> games = {};

  Game? getGame(String gameCode) {
    print(games);
    return games[gameCode];
  }

  Game? createGame({
    required String gameCode,
    String password = "",
  }) {
    // Check if game already exists
    Game? game = getGame(gameCode);
    if (game != null) {
      return null;
    }

    // Create new game
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
