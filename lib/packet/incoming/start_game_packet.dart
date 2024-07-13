import 'package:onu3_server/packet/incoming_packet.dart';

class StartGamePacket implements IncomingPacket {
  @override
  String get type => "start_game";

  StartGamePacket();

  factory StartGamePacket.fromJson(Map<String, dynamic> json) {
    return StartGamePacket();
  }
}
