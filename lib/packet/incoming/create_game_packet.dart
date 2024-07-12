import 'package:onu3_server/packet/incoming_packet.dart';

class CreateGamePacket implements IncomingPacket {
  @override
  String get type => "create_game";

  final String gameCode;
  String password;

  CreateGamePacket({
    required this.gameCode,
    this.password = "",
  });

  factory CreateGamePacket.fromJson(Map<String, dynamic> json) {
    return CreateGamePacket(
      gameCode: json["gameCode"],
      password: json["password"],
    );
  }
}
