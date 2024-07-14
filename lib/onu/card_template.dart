import 'package:onu3_server/onu/card.dart';
import 'package:onu3_server/onu/card_data.dart';

class CardTemplate {
  final String color;
  final String type;
  final CardData? data;

  const CardTemplate({
    required this.color,
    required this.type,
    this.data,
  });

  Card create() {
    return Card.create(color: color, type: type, data: data);
  }

  @override
  String toString() {
    return "CardTemplate{color: $color, type: $type, data: $data}";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["color"] = color;
    data["type"] = type;
    if (this.data != null) data["data"] = this.data!.toJson();

    return data;
  }
}
