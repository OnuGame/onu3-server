import 'package:onu3_server/websocket/connection.dart';
import 'package:test/test.dart';
import 'package:onu3_server/packet/outgoing/error_packet.dart';
import 'package:onu3_server/packet/outgoing/game_created_packet.dart';
import 'package:onu3_server/packet/outgoing/game_started_packet.dart';
import 'package:onu3_server/packet/outgoing/left_game_packet.dart';
import 'package:onu3_server/packet/outgoing/player_created_packet.dart';
import 'package:onu3_server/onu/player.dart';

void main() {
  group('OutgoingPacket', () {
    test('should create PlayerCreatedPacket and serialize to JSON', () {
      final packet = PlayerCreatedPacket(username: "player1");
      final json = packet.toJson();
      expect(json["type"], "player_created");
      expect(json["username"], "player1");
    });

    test('should create LeftGamePacket and serialize to JSON', () {
      final player =
          Player.create(connection: Connection.empty(), name: "name");
      final packet = LeftGamePacket(player: player);
      final json = packet.toJson();
      expect(json["type"], "left_game");
      expect(json["player"], player.toJson());
    });

    test('should create GameStartedPacket and serialize to JSON', () {
      final packet = GameStartedPacket();
      final json = packet.toJson();
      expect(json["type"], "game_started");
    });

    test('should create GameCreatedPacket and serialize to JSON', () {
      final packet = GameCreatedPacket(gameCode: "1234");
      final json = packet.toJson();
      expect(json["type"], "game_created");
      expect(json["gameCode"], "1234");
    });

    test('should create ErrorPacket and serialize to JSON', () {
      final packet = ErrorPacket(errorMessage: "An error occurred");
      final json = packet.toJson();
      expect(json["type"], "error");
      expect(json["errorMessage"], "An error occurred");
      expect(json["data"], {});
    });

    test('should create ErrorPacket with data and serialize to JSON', () {
      final packet = ErrorPacket(
        errorMessage: "An error occurred",
        data: {"key": "value"},
      );
      final json = packet.toJson();
      expect(json["type"], "error");
      expect(json["errorMessage"], "An error occurred");
      expect(json["data"], {"key": "value"});
    });
  });
}
