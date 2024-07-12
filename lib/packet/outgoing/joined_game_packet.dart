import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class JoinedGamePacket implements OutgoingPacket {
  @override
  String get type => "joined_game";

  final Player player;

  JoinedGamePacket({required this.player});

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "player": player.toJson(),
    };
  }
}
