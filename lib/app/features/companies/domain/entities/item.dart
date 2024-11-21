enum ItemType { location, asset }

class Item implements Entity {
  final String itemIid;
  final String itemName;
  final Entity? currentItem;
  final String? parentId;
  final String? locationId;
  final ItemType type;

  final List<Item> list;

  Item({
    this.parentId,
    this.locationId,
    this.currentItem,
    required this.itemIid,
    required this.itemName,
    required this.type,
    List<Item>? list,
  }) : list = list ?? [];
}

abstract class Entity {}
