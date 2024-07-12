import 'package:onu3_server/packet/incoming_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class SelectGameModePacket implements IncomingPacket, OutgoingPacket {
  @override
  String get type => "select_game_mode";

  final String gameModeName;

  SelectGameModePacket({
    required this.gameModeName,
  });

  factory SelectGameModePacket.fromJson(Map<String, dynamic> json) {
    return SelectGameModePacket(
      gameModeName: json["gameModeName"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "gameModeName": gameModeName,
    };
  }
}
