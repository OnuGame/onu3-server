import 'package:onu3_server/packet/incoming_packet.dart';

class JoinGamePacket implements IncomingPacket {
  @override
  String get type => "join_game";

  final String gameCode;
  final String username;
  String password;

  JoinGamePacket({
    required this.gameCode,
    required this.username,
    this.password = "",
  });

  factory JoinGamePacket.fromJson(Map<String, dynamic> json) {
    return JoinGamePacket(
      gameCode: json["gameCode"],
      username: json["username"],
      password: json["password"],
    );
  }
}
