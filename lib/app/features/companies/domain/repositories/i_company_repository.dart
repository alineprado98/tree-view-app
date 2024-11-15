import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

abstract class ICompanyRepository {
  Future<List<CompanyEntity>?> getCompanies();
  Future<void> firstLoadCompanies();
  Future<List<Item>> buildTheTree({required String companyId});
}
