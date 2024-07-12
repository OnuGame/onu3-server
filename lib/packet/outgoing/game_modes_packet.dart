import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class GameModesPacket implements OutgoingPacket {
  @override
  String get type => "game_modes";

  final List<GameMode> gameModes;

  GameModesPacket({
    required this.gameModes,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "gameModes": gameModes,
    };
  }
}
