import 'package:onu3_server/onu/game_mode/game_mode.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class UpdateGameModePacket implements OutgoingPacket {
  @override
  String get type => "update_game_mode";

  final GameMode gameMode;

  UpdateGameModePacket({
    required this.gameMode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "gameMode": gameMode,
    };
  }
}
