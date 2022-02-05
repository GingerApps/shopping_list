class Item {
  final String name;

  Item(this.name);

  factory Item.fromJson(Map<String, dynamic> json) => _itemFromJson(json);

  Map<String, dynamic> toJson() => _itemToJson(this);

  @override
  String toString() => 'Item<$name>';
}

Item _itemFromJson(Map<String, dynamic> json) {
  return Item(
    json['name'] as String,
  );
}

Map<String, dynamic> _itemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
    };
