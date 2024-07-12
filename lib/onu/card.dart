class Card {
  final String uuid;
  final String type;
  final String color;
  final Map<String, dynamic> data;

  Card({
    required this.uuid,
    required this.type,
    required this.color,
    this.data = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "color": color,
      "data": data,
    };
  }

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      uuid: json["uuid"],
      type: json["type"],
      color: json["color"],
      data: json["data"],
    );
  }

  @override
  String toString() {
    return "Card{uuid: $uuid, type: $type, color: $color, data: $data}";
  }

  @override
  bool operator ==(Object other) {
    if (other is Card) {
      return other.uuid == uuid;
    }
    return false;
  }

  @override
  int get hashCode => uuid.hashCode;

  Card copyWith({
    String? uuid,
    String? type,
    String? color,
    Map<String, dynamic>? data,
  }) {
    return Card(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      color: color ?? this.color,
      data: data ?? this.data,
    );
  }
}
