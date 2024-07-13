import 'package:onu3_server/packet/bidirectional/update_settings_packet.dart';
import 'package:onu3_server/packet/incoming/start_game_packet.dart';
import 'package:onu3_server/packet/incoming/create_game_packet.dart';
import 'package:onu3_server/packet/incoming/create_player_packet.dart';
import 'package:onu3_server/packet/incoming/join_game_packet.dart';
import 'package:onu3_server/packet/bidirectional/select_game_mode_packet.dart';
import 'package:onu3_server/packet/incoming/leave_game_packet.dart';
import 'package:onu3_server/packet/packet.dart';

abstract class IncomingPacket implements Packet {
  factory IncomingPacket.fromJson(Map<String, dynamic> json) {
    // We only need to map incoming packets
    switch (json["type"]) {
      case "join_game":
        return JoinGamePacket.fromJson(json);
      case "leave_game":
        return LeaveGamePacket.fromJson(json);
      case "create_game":
        return CreateGamePacket.fromJson(json);
      case "start_game":
        return StartGamePacket.fromJson(json);
      case "select_game_mode":
        return SelectGameModePacket.fromJson(json);
      case "create_player":
        return CreatePlayerPacket.fromJson(json);
      case "update_settings":
        return UpdateSettingsPacket.fromJson(json);

      default:
        throw Exception("Invalid packet type: ${json["type"]}");
    }
  }
}
