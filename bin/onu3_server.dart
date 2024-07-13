import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/incoming/create_player_packet.dart';
import 'package:onu3_server/packet/outgoing/player_created_packet.dart';
import 'package:onu3_server/websocket/connection.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  var handler =
      webSocketHandler((IOWebSocketChannel webSocket, String? protocol) {
    if (protocol == null || protocol != 'onu3') {
      webSocket.sink.close(1002, 'Invalid protocol');
      return;
    }

    Connection connection = Connection(webSocket);

    connection.on<CreatePlayerPacket>((packet) {
      print("Player ${packet.username} created");
      if (connection.player != null) {
        connection.player!.leaveGame();
      }

      connection.player = Player.create(
        connection: connection,
        name: packet.username,
      );

      connection.send(PlayerCreatedPacket(username: packet.username));
    });
  }, protocols: ['onu3']);

  shelf_io
      .serve(handler, 'localhost', 8080, poweredByHeader: "Onu3 Server")
      .then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}
