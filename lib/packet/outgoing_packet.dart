import 'package:onu3_server/packet/packet.dart';

abstract class OutgoingPacket implements Packet {
  Map<String, dynamic> toJson();
}
