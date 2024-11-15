//  "id": "656a07b3f2d4a1001e2144bf",
//   "name": "CHARCOAL STORAGE SECTOR",
//   "parentId": "65674204664c41001e91ecb4"
// se nao tiver um parentId quer dizer que é a local principal
//se existir parentId quer dizer que é sub location
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

class LocationEntity extends Item implements Entity {
  final String id;
  final String name;
  final String? parentId;
  final String? companyId;

  LocationEntity({
    required this.id,
    required this.name,
    required this.parentId,
    required this.companyId,
  }) : super(itemIid: id, itemName: name, type: ItemType.location);

  bool get isSubLocal => parentId?.isNotEmpty ?? false;

  factory LocationEntity.fromJson(Map<String, dynamic> json, String companyId) {
    try {
      return LocationEntity(
        id: json["id"],
        name: json["name"],
        parentId: json["parentId"],
        companyId: companyId,
      );
    } catch (e) {
      throw Exception('Error when serializate LocationEntity$e');
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parentId": parentId,
      };

  static Map<String, Object?> toLocalDatabase(LocationEntity entity, String companyId) {
    return {
      'id': entity.id,
      'name': entity.name,
      'parentId': entity.parentId,
      'companyId': companyId,
    };
  }
}
