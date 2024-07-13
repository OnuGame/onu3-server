import 'package:onu3_server/packet/incoming_packet.dart';

class CreatePlayerPacket implements IncomingPacket {
  @override
  String get type => "create_player";

  final String username;

  CreatePlayerPacket({
    required this.username,
  });

  factory CreatePlayerPacket.fromJson(Map<String, dynamic> json) {
    return CreatePlayerPacket(
      username: json["username"],
    );
  }
}
