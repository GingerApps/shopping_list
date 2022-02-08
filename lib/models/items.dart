class Item {
  final String name;
  final String measureUnit;
  final double quantity;

  Item(this.name, this.measureUnit, this.quantity);

  factory Item.fromJson(Map<String, dynamic> json) => _itemFromJson(json);

  Map<String, dynamic> toJson() => _itemToJson(this);
}

Item _itemFromJson(Map<String, dynamic> json) {
  return Item(
    json['name'] as String,
    json['measure_unit'] as String,
    json['quantity'] as double,
  );
}

Map<String, dynamic> _itemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'measure_unit': instance.measureUnit,
      'quantity': instance.quantity,
    };
