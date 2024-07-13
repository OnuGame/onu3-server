import 'package:onu3_server/packet/incoming_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class UpdateSettingsPacket implements IncomingPacket, OutgoingPacket {
  @override
  String get type => "update_settings";

  final Map<String, dynamic> settings;

  UpdateSettingsPacket({
    required this.settings,
  });

  factory UpdateSettingsPacket.fromJson(Map<String, dynamic> json) {
    return UpdateSettingsPacket(
      settings: json["settings"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "settings": settings,
    };
  }
}
