import 'package:onu3_server/packet/outgoing_packet.dart';

class PasswordInvalidPacket implements OutgoingPacket {
  @override
  String get type => "password_invalid";

  PasswordInvalidPacket();

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
    };
  }
}
