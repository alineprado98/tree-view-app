import 'package:tree_view_app/app/core/services/client/i_client.dart';
import 'package:tree_view_app/app/core/services/database/i_database.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_remote_repository.dart';

class CompanyRemoteRepository implements ICompanyRemoteRepository {
  final IClient clientService;
  final IDatabase databaseService;

  const CompanyRemoteRepository({required this.databaseService, required this.clientService});

  @override
  Future<void> firstLoadCompanies() async {
    try {
      final localCompanies = await getCompanies();
      if (localCompanies.isEmpty) {
        final companies = await getCompaniesApi();

        await saveCompanies(companies);
        for (var company in companies) {
          final locations = await getLocationsApi(company.id);
          saveLocations(locations, company.id);

          final assets = await getAssetsApi(company.id);
          saveAssets(assets, company.id);
        }
      }
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<List<CompanyEntity>> getCompaniesApi() async {
    try {
      final response = await clientService.get(url: '/companies');
      final companies = List.from(response.data).map((item) => CompanyEntity.fromJson(item)).toList();
      return companies;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<List<LocationEntity>> getLocationsApi(String companyId) async {
    try {
      final response = await clientService.get(url: '/companies/$companyId/locations');
      return List.from(response.data).map((item) => LocationEntity.fromJson(item, companyId)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getAssetsApi(String companyId) async {
    try {
      final response = await clientService.get(url: '/companies/$companyId/assets');
      return List.from(response.data).map((item) => AssetEntity.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveCompanies(List<CompanyEntity> companies) async {
    try {
      final response = companies.map((item) => CompanyEntity.toLocalDatabase(item)).toList();
      await databaseService.insertAll(tableName: 'companies', value: response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLocations(List<LocationEntity> locations, String companyId) async {
    try {
      final response = locations.map((item) => LocationEntity.toLocalDatabase(item, companyId)).toList();
      await databaseService.insertAll(tableName: 'locations', value: response);
    } catch (e) {}
  }

  Future<void> saveAssets(List<AssetEntity> assets, String companyId) async {
    try {
      final response = assets.map((item) => AssetEntity.toLocalDatabase(companyId: companyId, entity: item)).toList();
      await databaseService.insertAll(tableName: 'assets', value: response);
    } catch (e) {}
  }

  @override
  Future<List<CompanyEntity>> getCompanies() async {
    try {
      final result = await databaseService.get(tableName: 'companies');
      final companies = result.data!.result.map((item) => CompanyEntity.fromJson(item)).toList();
      return companies;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<List<LocationEntity>> getLocationByLisIds(List<String> locationsIds, String companyId) async {
    try {
      String ids = locationsIds.map((item) => "'$item'").join(' , ');
      String query = '''
    SELECT * 
FROM locations
WHERE companyId = "$companyId" 
  AND (
    id IN ($ids)
    OR parentId IN ($ids)
    OR parentId IS NULL 
    OR id IN (
        SELECT id
        FROM locations
        WHERE parentId IN ($ids)
          AND companyId = "$companyId"
    )
)

            ''';

      final result = await databaseService.query(query: query);

      final locations = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList();
      return locations;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  @override
  Future<List<LocationEntity>> getReletedLocationByLisIds(List<String> locationsIds, String companyId) async {
    try {
      String ids = locationsIds.map((item) => "'$item'").join(' , ');
      String query = '''
    SELECT * 
FROM locations
WHERE companyId = "$companyId" 
  AND (
    id IN ($ids)
    OR parentId IN ($ids)
    OR id IN (
        SELECT id
        FROM locations
        WHERE parentId IN ($ids)
          AND companyId = "$companyId"
    )
)

            ''';

      final result = await databaseService.query(query: query);

      final locations = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList();
      return locations;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<LocationEntity> getLocationById({required String companyId, String? locationId}) async {
    try {
      String query = '''
                  SELECT 
                      id,
                      name,
                      parentId,
                      companyId
                  FROM locations
                  WHERE companyId = "$companyId"
                  AND id = "$locationId"


          ''';

      final result = await databaseService.query(query: query);

      final location = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList().first;
      return location;
    } catch (e) {
      rethrow;
    }
  }

  Future<AssetEntity> getAssetById({required String companyId, String? parentId}) async {
    try {
      String query = '''
                  SELECT 
                      id,
                      name,
                      status,
                      sensorType,
                      sensorId,
                      gatewayId,
                      parentId,
                      companyId,
                      locationId
                  FROM assets
                  WHERE companyId = "$companyId"
                  AND id = "$parentId"


          ''';

      final result = await databaseService.query(query: query);

      final asset = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList().first;
      return asset;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getAssets({required String companyId, String? search}) async {
    try {
      String query = '''
      SELECT 
                id,
                name,
                status,
                sensorType,
                sensorId,
                gatewayId,
                parentId,
                companyId,
                locationId
            FROM 
                assets
            WHERE 
               companyId = "$companyId"

          ''';

      final result = await databaseService.query(query: query);

      final assets = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
      return assets;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LocationEntity>> getLocations({required String companyId, String? search}) async {
    try {
      String query = '''
            SELECT 
                id,
                name,
                parentId,
                companyId
           FROM 
                locations
            WHERE 
               companyId = "$companyId"
          ''';

      if (search != null) {
        query += '''  AND  name LIKE "%$search%" ''';
      }

      final result = await databaseService.query(query: query);
      final locations = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList();
      return locations;
    } catch (e) {
      rethrow;
    }
  }
}
