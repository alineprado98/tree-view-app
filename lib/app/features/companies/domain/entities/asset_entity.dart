import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

class AssetEntity extends Item {
  final String id;
  final String name;
  final String? sensorId;
  final String? gatewayId;
  final String? parentId;
  final String? locationId;
  final String? companyId;
  final AssetStatus? status;
  final AssetSensors? sensorType;

  AssetEntity({
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.locationId,
    required this.companyId,
  }) : super(
          itemIid: id,
          itemName: name,
          type: ItemType.asset,
        );

  factory AssetEntity.fromJson(Map<String, dynamic> json) {
    try {
      return AssetEntity(
        id: json["id"],
        name: json["name"],
        parentId: json["parentId"],
        sensorId: json["sensorId"],
        gatewayId: json["gatewayId"],
        locationId: json["locationId"],
        companyId: json["companyId"],
        status: AssetStatus.fromString(json["status"]),
        sensorType: AssetSensors.fromString(json["sensorType"]),
      );
    } catch (e) {
      throw Exception('Error when serializate AssetEntity, $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "parentId": parentId,
        "sensorId": sensorId,
        "gatewayId": gatewayId,
        "locationId": locationId,
        "companyId": companyId,
        "sensorType": sensorType,
      };

  static Map<String, Object?> toLocalDatabase({required AssetEntity entity, required companyId}) {
    return {
      "id": entity.id,
      "name": entity.name,
      "parentId": entity.parentId,
      "sensorId": entity.sensorId,
      "gatewayId": entity.gatewayId,
      "locationId": entity.locationId,
      "companyId": companyId,
      "status": entity.status?.name,
      "sensorType": entity.sensorType?.name,
    };
  }
}

enum AssetSensors {
  energy,
  vibration;

  static AssetSensors? fromString(String? code) {
    switch (code) {
      case 'energy':
        return AssetSensors.energy;

      case 'vibration':
        return AssetSensors.vibration;

      default:
        return null;
    }
  }
}

enum AssetStatus {
  alert,
  operating;

  static AssetStatus? fromString(String? code) {
    switch (code) {
      case 'alert':
        return AssetStatus.alert;

      case 'operating':
        return AssetStatus.operating;

      default:
        return null;
    }
  }
}
