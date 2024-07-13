import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/event/disconnect_event.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/game_manager.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/incoming/start_game_packet.dart';
import 'package:onu3_server/packet/incoming/create_game_packet.dart';
import 'package:onu3_server/packet/incoming/join_game_packet.dart';
import 'package:onu3_server/packet/incoming/leave_game_packet.dart';
import 'package:onu3_server/packet/outgoing/error_packet.dart';
import 'package:onu3_server/packet/outgoing/game_created_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';
import 'package:onu3_server/websocket/connection.dart';
import 'package:uuid/uuid.dart';

class Player {
  final Connection connection;
  final String uuid;
  final String name;
  Game? game;
  final List<Card> deck = [];
  get deckSize => deck.length;

  Player({
    required this.uuid,
    required this.connection,
    required this.name,
    this.game,
  }) {
    connection.on<CreateGamePacket>((packet) {
      Game? game = GameManager.instance.createGame(gameCode: packet.gameCode);
      if (game == null) {
        connection.send(ErrorPacket(
          errorMessage: "Game already exists",
          data: {'gameCode': packet.gameCode},
        ));
        return;
      }

      connection.send(GameCreatedPacket(gameCode: packet.gameCode));
    });

    connection.on<JoinGamePacket>((packet) {
      Game? game = GameManager.instance.getGame(packet.gameCode);
      if (game == null) {
        connection.send(ErrorPacket(
          errorMessage: "Game code Invalid",
          data: {'gameCode': packet.gameCode},
        ));
        return;
      }

      if (!game.join(player: this)) {
        connection.send(ErrorPacket(
          errorMessage: "Password Invalid",
          data: {'gameCode': packet.gameCode},
        ));
      }

      this.game = game;
    });

    connection.on<SelectGameModePacket>((packet) {
      if (game == null) return;
      game!.selectGameMode(this, packet.gameModeName);
    });

    connection.on<StartGamePacket>((packet) {
      if (game == null) return;
      try {
        game!.start(this);
      } catch (e) {
        connection.send(ErrorPacket(
          errorMessage: e.toString(),
        ));
      }
    });

    connection.on<LeaveGamePacket>((packet) {
      leaveGame();
    });

    connection.on<DisconnectEvent>((event) {
      leaveGame();
    });
  }

  factory Player.create({
    required Connection connection,
    required String name,
    Game? game,
  }) {
    return Player(
      uuid: Uuid().v4(),
      connection: connection,
      name: name,
      game: game,
    );
  }

  void leaveGame() {
    if (game != null) {
      game!.removePlayer(this);
      game = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "name": name,
      "deckSize": deckSize,
    };
  }

  void send(OutgoingPacket packet) {
    connection.send(packet);
  }
}
