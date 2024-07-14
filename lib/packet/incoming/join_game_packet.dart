import 'package:onu3_server/packet/incoming_packet.dart';

class JoinGamePacket implements IncomingPacket {
  @override
  String get type => "join_game";

  final String gameCode;
  String password;

  JoinGamePacket({
    required this.gameCode,
    this.password = "",
  });

  factory JoinGamePacket.fromJson(Map<String, dynamic> json) {
    return JoinGamePacket(
      gameCode: json["gameCode"],
      password: json["password"] ?? "",
    );
  }
}
