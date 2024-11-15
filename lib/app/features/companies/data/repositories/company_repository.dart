import 'package:tree_view_app/app/core/services/client/i_client.dart';
import 'package:tree_view_app/app/core/services/database/dtos/request/database_filter.dart';
import 'package:tree_view_app/app/core/services/database/i_database.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';

class CompanyRepository implements ICompanyRepository {
  final IClient clientService;
  final IDatabase databaseService;

  const CompanyRepository({required this.databaseService, required this.clientService});

  @override
  Future<void> firstLoadCompanies() async {
    try {
      final localCompanies = await getCompanies();
      if (localCompanies.isEmpty) {
        final companies = await getCompaniesApi();

        await saveCompanies(companies);
        for (var company in companies) {
          //save locations
          final locations = await getLocationsApi(company.id);
          saveLocations(locations, company.id);

          //save assets
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
      final response = await clientService.get(url: '/$companyId/locations');
      return List.from(response.data).map((item) => LocationEntity.fromJson(item, companyId)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getAssetsApi(String companyId) async {
    try {
      final response = await clientService.get(url: '/$companyId/assets');
      return List.from(response.data).map((item) => AssetEntity.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
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

  Future<List<LocationEntity>> getlocations(String companyId) async {
    try {
      final result = await databaseService.query(query: '''
            SELECT 
                id,
                name,
                parentId,
                companyId
            FROM 
                locations
            WHERE 
                parentId IS NULL AND companyId = "$companyId";
   
        ''');

      final locations = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList();
      return locations;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<List<AssetEntity>> getAssets(String companyId) async {
    try {
      final result = await databaseService.query(query: '''
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
               companyId = "$companyId";
   
        ''');

      final assets = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
      return assets;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getExternalAssetsByCompany(String companyId) async {
    try {
      final result = await databaseService.query(query: '''
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
                parentId IS NULL AND locationId IS NULL and companyId = "$companyId";
   
        ''');

      final assets = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
      return assets;
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
  Future<List<Item>> buildTheTree({required String companyId}) async {
    final locationList = await getlocations(companyId);
    List<Item> items = [];
    for (var item in locationList) {
      final loadedItem = await build(item);
      items.add(loadedItem);
    }

    // Find components assetExternal
    final listExternalAssetsByCompany = await getExternalAssetsByCompany(companyId);

    items.addAll(listExternalAssetsByCompany);
    sortList(items);
    return items;
  }

  Future<Item> build(LocationEntity item) async {
    List<Item> itemsAssets = [];
    var currentItemLocation = Item(itemName: item.name, itemIid: item.id, type: ItemType.location, currentItem: item);
    // checks if there are assets
    final assetList = await getAssetByLocation(item.id);
    for (var itemAsset in assetList) {
      final loadedItem = await buildAssets(itemAsset, item.id);
      itemsAssets.add(loadedItem);
    }
    final externalAssetsByLocation = await getExternalAssetByLocation(item.companyId!, item.id);

    itemsAssets.addAll(externalAssetsByLocation);
    sortList(itemsAssets);

    currentItemLocation.list.addAll(itemsAssets);

    try {
      var subs = await getSubLocations(item.companyId!, item.id);
      if (subs.isNotEmpty) {
        for (var i in subs) {
          var item = await build(i);
          currentItemLocation.list.add(item);
        }
      }

      return currentItemLocation;
    } catch (e) {
      rethrow;
    }
  }

  Future<Item> buildAssets(AssetEntity itemAsset, String locationId) async {
    var currentItem = Item(itemName: itemAsset.name, itemIid: itemAsset.id, type: ItemType.asset, currentItem: itemAsset);
    try {
      final assetByLocation = await getAssetByLocation(locationId);
      if (assetByLocation.isNotEmpty) {
        var subAssets = await getSubAssets(itemAsset, locationId);
        if (subAssets.isNotEmpty) {
          for (var i in subAssets) {
            var item = await buildAssets(i, locationId);
            currentItem.list.add(item);
          }
        }
      }

      return currentItem;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationEntity>> getSubLocations(String companyId, String locationId) async {
    try {
      final result = await databaseService.get(
          tableName: 'locations',
          filters: DatabaseFilter(whereArgs: [
            {"parentId": locationId},
            {"companyId": companyId},
          ]));
      if (result.data!.result.isNotEmpty) {
        final subs = result.data!.result.map((item) => LocationEntity.fromJson(item, companyId)).toList();
        return subs;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getSubAssets(AssetEntity asset, String locationId) async {
    try {
      final result = await databaseService.get(
          tableName: 'assets',
          filters: DatabaseFilter(whereArgs: [
            {"parentId": asset.id},
          ]));
      if (result.data!.result.isNotEmpty) {
        final subs = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
        return subs;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getAssetByLocation(String locationId) async {
    try {
      final result = await databaseService.get(
          tableName: 'assets',
          filters: DatabaseFilter(whereArgs: [
            {"locationId": locationId},
          ]));
      if (result.data!.result.isNotEmpty) {
        final subs = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
        return subs;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssetEntity>> getExternalAssetByLocation(String locationId, String companyId) async {
    try {
      final result = await databaseService.query(query: '''
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
                parentId IS NULL AND locationId ="$locationId" AND companyId = "$companyId";
   
        ''');

      final assets = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
      return assets;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  Future<List<AssetEntity>> getExternalAssetByAsset(String assetId, String companyId) async {
    try {
      final result = await databaseService.query(query: '''
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
                locationId IS NULL AND parentId ="$assetId" AND companyId = "$companyId";
   
        ''');

      final assets = result.data!.result.map((item) => AssetEntity.fromJson(item)).toList();
      return assets;
    } catch (e) {
      print('error $e');
      rethrow;
    }
  }

  List<Item> sortList(List<Item> list) {
    list.sort((a, b) {
      if (a.list.isNotEmpty && (b.list.isEmpty)) {
        return -1;
      } else if ((a.list.isEmpty || a.list.isEmpty) && (b.list.isNotEmpty && b.list.isNotEmpty)) {
        return 1;
      } else {
        return 0;
      }
    });
    return list;
  }
}
