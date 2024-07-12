import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/game_mode/classic_game_mode.dart';
import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/outgoing/joined_game_packet.dart';
import 'package:onu3_server/packet/outgoing/left_game_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class Game {
  final String gameCode;
  String? password;
  GameMode gameMode = ClassicGameMode();
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
    required player,
  }) {
    players.add(player);

    print("Player ${player.name} joined game $gameCode");
    broadcast(JoinedGamePacket(player: player));
  }

  void removePlayer(Player player) {
    players.remove(player);
    broadcast(LeftGamePacket(player: player));
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
    return "Game{$gameCode, $players}";
  }
}
