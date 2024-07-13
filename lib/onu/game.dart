import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game_manager.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/onu/game_mode/game_mode_registry.dart';
import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/outgoing/game_modes_packet.dart';
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

  get playerCount => players.length;
  get isPrivate => password != null && password!.isNotEmpty;

  Game({
    required this.gameCode,
    String password = "",
  }) {
    Uint8List bytes = utf8.encode(password);
    this.password = sha256.convert(bytes).toString();
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
  }) {
    players.add(player);

    print("Player ${player.name} joined game $gameCode");
    broadcast(JoinedGamePacket(player: player));
    player.send(UpdatePlayerListPacket(playerList: players));
    player.send(GameModesPacket(
      gameModes: GameModeRegistry.gameModes,
    ));
  }

  void removePlayer(Player player) {
    players.remove(player);
    broadcast(LeftGamePacket(player: player));
    if (players.isEmpty) {
      GameManager.instance.removeGame(gameCode);
    }
  }

  void selectGameMode(Player player, String gameModeName) {
    if (players.indexOf(player) != 0) return;

    GameMode? gameMode = GameModeRegistry.getGameMode(gameModeName);
    if (gameMode == null) {
      return;
      // TODO - send game mode invalid packet -> maybe even generic error packet
    }

    this.gameMode = gameMode;

    settings.clear();
    for (var setting in gameMode.settings) {
      settings[setting.name] = setting.defaultValue;
    }

    broadcast(SelectGameModePacket(gameModeName: gameModeName));
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
