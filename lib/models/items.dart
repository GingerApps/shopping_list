class Item {
  final String name;
  final String measureUnit;

  Item(this.name, this.measureUnit);

  factory Item.fromJson(Map<String, dynamic> json) => _itemFromJson(json);

  Map<String, dynamic> toJson() => _itemToJson(this);

  @override
  String toString() {
    return 'Item{name: $name, measureUnit: $measureUnit}';
  }

// @override
  // String toString() => 'Item<$name>';
}

Item _itemFromJson(Map<String, dynamic> json) {
  return Item(
    json['name'] as String,
    json['measure_unit'] as String,
  );
}

Map<String, dynamic> _itemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'measure_unit': instance.measureUnit,
    };
