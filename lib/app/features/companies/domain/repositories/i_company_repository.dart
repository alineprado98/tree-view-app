import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

abstract class ICompanyRepository {
  Future<List<Item>> buildTheTree({required String companyId});
  Future<List<Item>> filter({
    required String companyId,
    String? searchField,
    bool? criticalFilter,
    bool? sensorEnergyFilter,
  });
}
