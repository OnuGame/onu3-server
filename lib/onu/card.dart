import 'package:onu3_server/utils/random_string.dart';

class Card {
  final String id;
  final String type;
  final String color;
  final Map<String, dynamic> data;

  const Card({
    required this.id,
    required this.type,
    required this.color,
    this.data = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "color": color,
      "data": data,
    };
  }

  factory Card.create(
      {required String type,
      required String color,
      Map<String, dynamic> data = const {}}) {
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
    Map<String, dynamic>? data,
  }) {
    return Card(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      data: data ?? this.data,
    );
  }
}
