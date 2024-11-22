import 'package:tree_view_app/app/common/exceptions/base_exception.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

abstract class ICompanyRepository {
  Future<(List<Item>, BaseException?)> buildTheTree({required String companyId});
  Future<(List<Item>, BaseException?)> filter({
    required String companyId,
    String? searchField,
    bool? criticalFilter,
    bool? sensorEnergyFilter,
  });
}
