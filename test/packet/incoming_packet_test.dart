import 'package:test/test.dart';
import 'package:onu3_server/packet/incoming_packet.dart';
import 'package:onu3_server/packet/incoming/create_game_packet.dart';
import 'package:onu3_server/packet/incoming/create_player_packet.dart';
import 'package:onu3_server/packet/incoming/start_game_packet.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/bidirectional/update_settings_packet.dart';

void main() {
  group('IncomingPacket.fromJson', () {
    test('should create CreateGamePacket from JSON', () {
      final json = {
        "type": "create_game",
        "gameCode": "1234",
        "password": "secret",
      };
      final packet = IncomingPacket.fromJson(json) as CreateGamePacket;
      expect(packet.type, "create_game");
      expect(packet.gameCode, "1234");
      expect(packet.password, "secret");
    });

    test('should create CreatePlayerPacket from JSON', () {
      final json = {
        "type": "create_player",
        "username": "player1",
      };
      final packet = IncomingPacket.fromJson(json) as CreatePlayerPacket;
      expect(packet.type, "create_player");
      expect(packet.username, "player1");
    });

    test('should create StartGamePacket from JSON', () {
      final json = {
        "type": "start_game",
      };
      final packet = IncomingPacket.fromJson(json) as StartGamePacket;
      expect(packet.type, "start_game");
    });

    test('should create SelectGameModePacket from JSON', () {
      final json = {
        "type": "select_game_mode",
        "gameModeName": "mode1",
      };
      final packet = IncomingPacket.fromJson(json) as SelectGameModePacket;
      expect(packet.type, "select_game_mode");
      expect(packet.gameModeName, "mode1");
    });

    test('should create UpdateSettingsPacket from JSON', () {
      final json = {
        "type": "update_settings",
        "settings": {
          "key": "value",
        },
      };
      final packet = IncomingPacket.fromJson(json) as UpdateSettingsPacket;
      expect(packet.type, "update_settings");
      expect(packet.settings, {"key": "value"});
    });

    test('should throw exception for invalid packet type', () {
      final json = {
        "type": "invalid_type",
      };
      expect(() => IncomingPacket.fromJson(json), throwsException);
    });
  });
}
