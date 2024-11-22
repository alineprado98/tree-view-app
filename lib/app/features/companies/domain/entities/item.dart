enum ItemType { location, asset }

class Item {
  final String itemIid;
  final String itemName;
  final String? parentIdItem;
  final String? locationId;
  final ItemType type;
  final List<Item> list;

  Item({
    this.parentIdItem,
    this.locationId,
    required this.itemIid,
    required this.itemName,
    required this.type,
    List<Item>? list,
  }) : list = list ?? [];
}
