class CardData {
  final int? drawAmount;

  const CardData({
    this.drawAmount,
  });

  @override
  String toString() {
    return "CardData{drawAmount: $drawAmount}";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if (drawAmount != null) data["drawAmount"] = drawAmount;

    return data;
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      drawAmount: json["drawAmount"],
    );
  }
}
