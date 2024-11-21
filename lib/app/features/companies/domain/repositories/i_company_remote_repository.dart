import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';

abstract class ICompanyRemoteRepository {
  Future<void> firstLoadCompanies();

  Future<List<CompanyEntity>?> getCompanies();

  Future<List<LocationEntity>> getLocationByLisIds(List<String> locationsIds, String companyId);

  Future<LocationEntity> getLocationById({required String companyId, String? locationId});

  Future<AssetEntity> getAssetById({required String companyId, String? parentId});
  Future<List<LocationEntity>> getReletedLocationByLisIds(List<String> locationsIds, String companyId);

  Future<List<AssetEntity>> getAssets({required String companyId, String? search});
  Future<List<LocationEntity>> getLocations({required String companyId, String? search});
}
