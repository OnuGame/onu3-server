class Setting {
  final String name;
  final dynamic defaultValue;
  final List<dynamic>? options;

  Setting({
    required this.name,
    required this.defaultValue,
    this.options,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      name: json['name'],
      defaultValue: json['defaultValue'],
      options: json['options'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'defaultValue': defaultValue,
      'options': options,
    };
  }

  @override
  String toString() {
    return 'Setting{name: $name, defaultValue: $defaultValue, options: $options}';
  }
}
