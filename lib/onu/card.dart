import 'package:onu3_server/onu/card_data.dart';
import 'package:onu3_server/utils/random_string.dart';

class Card {
  final String id;
  final String type;
  final String color;
  final CardData? data;

  const Card({
    required this.id,
    required this.type,
    required this.color,
    this.data = const CardData(drawAmount: null),
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["type"] = type;
    data["color"] = color;
    if (this.data != null) data["data"] = this.data!.toJson();

    return data;
  }

  factory Card.create(
      {required String type, required String color, CardData? data}) {
    return Card(
      id: RandomString.generate(7),
      type: type,
      color: color,
      data: data,
    );
  }

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json["id"],
      type: json["type"],
      color: json["color"],
      data: json["data"],
    );
  }

  @override
  String toString() {
    return "Card{id: $id, type: $type, color: $color, data: $data}";
  }

  @override
  bool operator ==(Object other) {
    if (other is Card) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  Card copyWith({
    String? id,
    String? type,
    String? color,
    CardData? data,
  }) {
    return Card(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      data: data ?? this.data,
    );
  }
}
