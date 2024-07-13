import 'package:onu3_server/onu/card.dart';

class CardTemplate {
  final String color;
  final String type;
  final Map<String, dynamic> data;

  const CardTemplate({
    required this.color,
    required this.type,
    required this.data,
  });

  Card create() {
    return Card.create(color: color, type: type, data: data);
  }
}
