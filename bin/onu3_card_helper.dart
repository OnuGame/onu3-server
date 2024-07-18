import 'dart:io';

import 'package:onu3_server/svg/card_builder.dart';
import 'package:onu3_server/svg/theme.dart';

void main() {
  var cardSvgString = CardBuilder(
    basePath: 'assets/classic/ColorCard.svg',
    layerPaths: [
      'assets/classic/types/5.svg',
    ],
    color: "#8200fa",
    theme: Theme.dark,
  ).build();

  File('8200fa-p-l.svg').writeAsStringSync(cardSvgString);
}
