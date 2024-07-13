import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class UpdatePlayerListPacket implements OutgoingPacket {
  @override
  String get type => "update_player_list";

  final List<Player> playerList;

  UpdatePlayerListPacket({
    required this.playerList,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "playerList": playerList,
    };
  }
}
