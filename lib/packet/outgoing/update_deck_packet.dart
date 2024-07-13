import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';

class UpdateDeckPacket implements OutgoingPacket {
  @override
  String get type => "update_deck";

  final List<Card> deck;

  UpdateDeckPacket({
    required this.deck,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "deck": deck,
    };
  }
}
