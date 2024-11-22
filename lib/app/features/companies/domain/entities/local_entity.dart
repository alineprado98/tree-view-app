import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

class LocationEntity extends Item {
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
