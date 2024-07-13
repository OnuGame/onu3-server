import 'package:onu3_server/packet/incoming_packet.dart';

class LeaveGamePacket implements IncomingPacket {
  @override
  String get type => "leave_game";

  LeaveGamePacket();

  factory LeaveGamePacket.fromJson(Map<String, dynamic> json) {
    return LeaveGamePacket();
  }
}
