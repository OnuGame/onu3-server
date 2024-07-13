import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/event/disconnect_event.dart';
import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';
import 'package:onu3_server/websocket/connection.dart';
import 'package:uuid/uuid.dart';

class Player {
  final Connection connection;
  final String uuid;
  final String name;
  final Game game;
  final List<Card> deck = [];
  get deckSize => deck.length;

  Player({
    required this.uuid,
    required this.connection,
    required this.name,
    required this.game,
  }) {
    connection.on<DisconnectEvent>((event) {
      game.removePlayer(this);
    });

    connection.on<SelectGameModePacket>((packet) {
      game.selectGameMode(this, packet.gameModeName);
    });
  }

  factory Player.create({
    required Connection connection,
    required String name,
    required Game game,
  }) {
    return Player(
      uuid: Uuid().v4(),
      connection: connection,
      name: name,
      game: game,
    );
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
