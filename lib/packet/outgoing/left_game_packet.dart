import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class LeftGamePacket implements OutgoingPacket {
  @override
  String get type => "left_game";

  final Player player;

  LeftGamePacket({required this.player});

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "player": player.toJson(),
    };
  }
}
