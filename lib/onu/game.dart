import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game_manager.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/onu/game_mode/game_mode_registry.dart';
import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/bidirectional/update_settings_packet.dart';
import 'package:onu3_server/packet/outgoing/game_modes_packet.dart';
import 'package:onu3_server/packet/outgoing/game_started_packet.dart';
import 'package:onu3_server/packet/outgoing/joined_game_packet.dart';
import 'package:onu3_server/packet/outgoing/left_game_packet.dart';
import 'package:onu3_server/packet/outgoing/update_player_list_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class Game {
  final String gameCode;
  String? password;
  GameMode gameMode = GameModeRegistry.gameModes.first;
  Map<String, dynamic> settings = {};
  final List<Player> players = [];
  final List<Card> stack = [];
  bool running = false;

  get playerCount => players.length;
  get isPrivate => password != null && password!.isNotEmpty;

  Game({
    required this.gameCode,
    String password = "",
  }) {
    Uint8List bytes = utf8.encode(password);
    this.password = sha256.convert(bytes).toString();

    settings.clear();
    for (var setting in gameMode.settings) {
      settings[setting.name] = setting.defaultValue;
    }
  }

  bool verifyPassword(String password) {
    if (this.password == null) return true;
    Uint8List bytes = utf8.encode(password);
    String hashed = sha256.convert(bytes).toString();
    print(
        "Verifying password '${hashed.substring(0, 7)}' against '${this.password!.substring(0, 7)}'");
    return this.password == hashed;
  }

  void join({
    required Player player,
    String password = "",
  }) {
    if (isPrivate && !verifyPassword(password)) throw "Password Invalid";

    players.add(player);

    print("Player ${player.name} joined game $gameCode");
    broadcast(JoinedGamePacket(player: player));
    player.send(UpdatePlayerListPacket(playerList: players));
    player.send(GameModesPacket(
      gameModes: GameModeRegistry.gameModes,
    ));
  }

  void removePlayer(Player player) {
    broadcast(LeftGamePacket(player: player));
    players.remove(player);
    if (players.isEmpty) {
      GameManager.instance.removeGame(gameCode);
    }
  }

  void selectGameMode(Player player, String gameModeName) {
    if (players.indexOf(player) != 0) {
      throw "Only the host can select the game mode";
    }

    GameMode? gameMode = GameModeRegistry.getGameMode(gameModeName);
    if (gameMode == null) throw "Game mode not found";

    this.gameMode = gameMode;

    settings.clear();
    for (var setting in gameMode.settings) {
      settings[setting.name] = setting.defaultValue;
    }

    broadcast(SelectGameModePacket(gameModeName: gameModeName));
  }

  void updateSettings(Player player, Map<String, dynamic> settings) {
    if (players.indexOf(player) != 0) throw "Only the host can update settings";

    // TODO - validate settings -> Check if types are equal to default values and if they are in the list of possible values

    this.settings = settings;
    broadcast(UpdateSettingsPacket(settings: settings));
  }

  void start(Player player) {
    if (players.indexOf(player) != 0) throw "Only the host can start the game";
    if (running) throw "Game is already running";

    broadcast(GameStartedPacket());

    running = true;
    gameMode.startGame(this);
  }

  void end() {
    running = false;
    gameMode.endGame(this);
  }

  void addCardToStack(Card card) {
    stack.add(card);
  }

  void broadcast(OutgoingPacket packet) {
    for (Player player in players) {
      player.send(packet);
    }
  }

  @override
  String toString() {
    return "Game{$gameCode, $players, $settings}";
  }
}
