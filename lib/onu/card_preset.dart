import 'package:onu3_server/onu/card_data.dart';
import 'package:onu3_server/onu/card_template.dart';

class CardPreset {
  final List<String> colors;
  final List<String> types;
  final List<CardData> datas;

  const CardPreset({
    required this.colors,
    required this.types,
    required this.datas,
  });

  List<CardTemplate> generateCardTemplates() {
    List<CardTemplate> templates = [];
    for (String color in colors) {
      for (String type in types) {
        if (datas.isEmpty) {
          templates.add(CardTemplate(color: color, type: type));
        } else {
          for (CardData data in datas) {
            templates.add(CardTemplate(color: color, type: type, data: data));
          }
        }
      }
    }
    return templates;
  }
}
