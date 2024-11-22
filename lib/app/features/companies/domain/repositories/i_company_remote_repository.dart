import 'package:tree_view_app/app/common/exceptions/base_exception.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';

abstract class ICompanyRemoteRepository {
  Future<void> firstLoadCompanies();

  Future<(List<CompanyEntity>, BaseException?)> getCompanies();

  Future<AssetEntity> getAssetById({
    required String companyId,
    String? parentId,
  });

  Future<List<AssetEntity>> getAssets({
    required String companyId,
    String? search,
    bool? criticalFilter,
    bool? sensorEnergyFilter,
  });

  Future<List<LocationEntity>> getLocationsByLisIds(
    List<String> locationsIds,
    String companyId,
  );
  Future<List<LocationEntity>> getReletedLocationsByLisIds(
    List<String> locationsIds,
    String companyId,
  );

  Future<List<LocationEntity>> getLocations({
    required String companyId,
    String? search,
  });
  Future<List<LocationEntity>> getlocationsToFilter(
    List<String> locationsIds,
    String companyId,
    String? search,
  );
}
