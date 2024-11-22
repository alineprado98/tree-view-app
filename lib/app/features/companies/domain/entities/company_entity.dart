class CompanyEntity {
  final String id;
  final String name;

  const CompanyEntity({
    required this.id,
    required this.name,
  }) : super();

  factory CompanyEntity.fromJson(Map<String, dynamic> json) {
    try {
      return CompanyEntity(
        id: json["id"],
        name: json["name"],
      );
    } catch (e) {
      throw Exception('Error when serializate CompanyEntity, $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static Map<String, Object?> toLocalDatabase(CompanyEntity entity) {
    return {
      'id': entity.id,
      'name': entity.name,
    };
  }
}
