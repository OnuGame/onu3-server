import 'package:onu3_server/svg/theme.dart';
import 'package:xml/xml.dart';
import 'dart:io';

class CardBuilder {
  final List<XmlElement> _layers = [];
  String _styles = "";

  CardBuilder({
    required basePath,
    required layerPaths,
    String? color,
    String? customStyles,
    Theme theme = Theme.light, // TODO implement theme
    int drawAmount = 0, // TODO implement drawAmount
  }) {
    for (var layerPath in [basePath, ...layerPaths]) {
      var fileContent = File(layerPath).readAsStringSync();
      var layer = XmlDocument.parse(fileContent).rootElement;

      _layers.add(layer);
    }

    _styles = _concatStyles();

    if (color != null) {
      _styles += ".color {fill: $color;}";
    }

    if (customStyles != null) {
      _styles += customStyles;
    }
  }

  String _concatStyles() {
    String styles = "";

    for (var layer in _layers) {
      var layerStyle = layer.findAllElements('style');
      for (var style in layerStyle) {
        styles += style.innerText;
      }
    }
    return styles;
  }

  void removeDefs() {
    for (var layer in _layers) {
      var defs = layer.findAllElements('defs');
      for (var def in defs) {
        def.remove();
      }
    }
  }

  String build() {
    removeDefs();

    var svg = XmlDocument.parse(
            '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
            '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">'
            '<defs><style>$_styles</style></defs>'
            '</svg>')
        .rootElement;

    List<XmlElement> elements = [];
    for (var layer in _layers) {
      // get all children of layer except of style
      var children = layer.children.whereType<XmlElement>();
      elements.addAll(children);
    }

    for (var element in elements) {
      element.detachParent(element.parentElement!);
      svg.children.add(element);
    }

    return svg.toXmlString(pretty: true, indent: '  ');
  }
}
