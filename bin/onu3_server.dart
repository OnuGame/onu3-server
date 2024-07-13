import 'package:onu3_server/onu/game.dart';
import 'package:onu3_server/onu/game_manager.dart';
import 'package:onu3_server/onu/game_mode/game_mode_registry.dart';
import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/incoming/create_game_packet.dart';
import 'package:onu3_server/packet/incoming/join_game_packet.dart';
import 'package:onu3_server/packet/outgoing/game_created_packet.dart';
import 'package:onu3_server/packet/outgoing/game_exists_packet.dart';
import 'package:onu3_server/packet/outgoing/game_invalid_packet.dart';
import 'package:onu3_server/packet/outgoing/password_invalid_packet.dart';
import 'package:onu3_server/packet/outgoing/game_modes_packet.dart';
import 'package:onu3_server/websocket/connection.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/io.dart';

bool joinGame(Connection connection, JoinGamePacket packet) {
  print("Player ${packet.username} tries to join game ${packet.gameCode}");

  Game? game = GameManager.instance.getGame(packet.gameCode);
  if (game == null) {
    connection.send(GameInvalidPacket(gameCode: packet.gameCode));
    print(
        "Denied access for player ${packet.username} to game ${packet.gameCode}: game does not exist");
    return false;
  }

  if (!game.verifyPassword(packet.password)) {
    connection.send(PasswordInvalidPacket());
    print(
        "Denied access for player ${packet.username} to game ${packet.gameCode}: invalid password");
    return false;
  }

  game.join(
    player: Player.create(
      connection: connection,
      name: packet.username,
      game: game,
    ),
  );

  return true;
}

void createGame(Connection connection, CreateGamePacket packet) {
  print("Someone tries to create game ${packet.gameCode}");

  Game? game = GameManager.instance.getGame(packet.gameCode);
  if (game != null) {
    connection.send(GameExistsPacket(gameCode: packet.gameCode));
    print(
        "Denied access to create game ${packet.gameCode}: game already exists");

    return;
  }

  GameManager.instance.createGame(
    gameCode: packet.gameCode,
    password: packet.password,
  );

  connection.send(GameCreatedPacket(gameCode: packet.gameCode));
}

void main() {
  var handler =
      webSocketHandler((IOWebSocketChannel webSocket, String? protocol) {
    if (protocol == null || protocol != 'onu3') {
      webSocket.sink.close(1002, 'Invalid protocol');
      return;
    }

    Connection connection = Connection(webSocket);

    connection.on<CreateGamePacket>((packet) {
      createGame(connection, packet);
    });

    connection.on<JoinGamePacket>((packet) {
      if (!joinGame(connection, packet)) return;

      connection.send(GameModesPacket(
        gameModes: GameModeRegistry.gameModes,
      ));
    });
  }, protocols: ['onu3']);

  shelf_io
      .serve(handler, 'localhost', 8080, poweredByHeader: "Onu3 Server")
      .then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}
