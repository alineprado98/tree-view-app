import 'package:tree_view_app/app/common/exceptions/base_exception.dart';
import 'package:tree_view_app/app/common/services/database/i_database.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_remote_repository.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';

class CompanyRepository implements ICompanyRepository {
  final IDatabase databaseService;
  final ICompanyRemoteRepository remoteRepository;

  const CompanyRepository({required this.databaseService, required this.remoteRepository});

  @override
  Future<(List<Item>, BaseException?)> buildTheTree({
    required String companyId,
  }) async {
    List<AssetEntity> assets = await remoteRepository.getAssets(companyId: companyId);
    Map<String, AssetEntity> itemMap = {};
    for (var item in assets) {
      itemMap[item.id] = item;
    }

    List<Item> builtAssets = [];
    List<Item> builtItems = [];

    for (var item in assets) {
      if (item.parentId == null) {
        builtAssets.add(item);
      } else {
        final parent = itemMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
      }
    }
    List<String> listIds = [];
    builtAssets.forEach((asset) => asset.locationId != null ? listIds.add(asset.locationId!) : null);
    final (List<Item>, Map<String, LocationEntity>) locationsResult = await buildLocations(listIds, companyId);
    builtItems.addAll(locationsResult.$1);

    for (var asset in builtAssets) {
      if (asset.locationId != null) {
        locationsResult.$2[asset.locationId]?.list.add(asset);
      } else {
        builtItems.add(asset);
      }
    }

    sortList(builtItems);
    return (builtItems, null);
  }

  @override
  Future<(List<Item>, BaseException?)> filter({
    required String companyId,
    String? searchField,
    bool? criticalFilter,
    bool? sensorEnergyFilter,
  }) async {
    List<AssetEntity> moreAssets = [];
    Map<String, AssetEntity> itemMap = {};
    List<Item> builtAssets = [];
    List<Item> builtItems = [];

    List<AssetEntity> assets = await remoteRepository.getAssets(
      companyId: companyId,
      search: searchField,
      criticalFilter: criticalFilter,
      sensorEnergyFilter: sensorEnergyFilter,
    );

    for (var i in assets) {
      if (i.parentId != null) {
        if (!assets.any((existingAsset) => existingAsset.id == i.parentId)) {
          final parentAsset = await remoteRepository.getAssetById(companyId: companyId, parentId: i.parentId);
          if (!moreAssets.any((existingAsset) => existingAsset.id == parentAsset.id)) {
            moreAssets.add(parentAsset);
          }
        }
      }
    }
    if (moreAssets.isNotEmpty) assets.addAll(moreAssets);

    for (var item in assets) {
      itemMap[item.id] = item;
    }
    for (var item in assets) {
      if (item.parentId == null) {
        builtAssets.add(item);
      } else {
        final parent = itemMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
      }
    }

    List<String> listIds = [];
    builtAssets.forEach((asset) => asset.locationId != null ? listIds.add(asset.locationId!) : null);
    (List<Item>, Map<String, LocationEntity>) locationsResult = await buildLocationsToAssetsFilter(listIds, companyId, searchField);
    builtItems.addAll(locationsResult.$1);

    for (var asset in builtAssets) {
      if (asset.locationId != null) {
        locationsResult.$2[asset.locationId]?.list.add(asset);
      } else {
        builtItems.add(asset);
      }
    }

    if (searchField != null) {
      List<LocationEntity> filteredLocations = await remoteRepository.getLocations(
        companyId: companyId,
        search: searchField,
      );
      if (filteredLocations.isNotEmpty) {
        List<String> listLocationsIds = [];
        filteredLocations.forEach((loc) => listLocationsIds.add(loc.id));
        (List<Item>, Map<String, LocationEntity>) builtLocations = await buildLocationsToFilter(
          listLocationsIds,
          companyId,
        );

        for (var loc in builtLocations.$1) {
          final alreadyExistsInList = builtItems.any((existsItem) => existsItem.itemIid == loc.itemIid);
          if (alreadyExistsInList == true) {
            builtItems.removeWhere((i) => i.itemIid == loc.itemIid);
          }
          builtItems.add(loc);
        }
      }
    }
    return (builtItems, null);
  }

  Future<(List<Item>, Map<String, LocationEntity>)> buildLocationsToFilter(List<String> listIds, String companyId) async {
    final locations = await remoteRepository.getReletedLocationsByLisIds(listIds, companyId);
    List<Item> builtLocations = [];
    List<Item> builtAssets = [];

    List<AssetEntity> assets = await remoteRepository.getAssets(companyId: companyId);
    Map<String, AssetEntity> itemMap = {};
    for (var item in assets) {
      itemMap[item.id] = item;
    }

    for (var item in assets) {
      if (item.parentId == null) {
        builtAssets.add(item);
      } else {
        final parent = itemMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
      }
    }

    Map<String, LocationEntity> locationMap = {};
    for (var item in locations) {
      locationMap[item.id] = item;
    }

    for (var item in locations) {
      if (item.parentId == null) {
        final alreadyExistsInList = builtLocations.any((existsItem) => existsItem.itemIid == item.itemIid);
        if (alreadyExistsInList == false) {
          builtLocations.add(item);
        }
      } else {
        final parent = locationMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
      }
    }
    for (var asset in builtAssets) {
      if (asset.locationId != null) {
        locationMap[asset.locationId]?.list.add(asset);
      }
    }

    return (builtLocations, locationMap);
  }

  Future<(List<Item>, Map<String, LocationEntity>)> buildLocations(List<String> listIds, String companyId) async {
    final locations = await remoteRepository.getLocationsByLisIds(listIds, companyId);
    List<Item> builtLocations = [];
    Map<String, LocationEntity> locationMap = {};
    for (var item in locations) {
      locationMap[item.id] = item;
    }

    for (var item in locations) {
      if (item.parentId == null) {
        final alreadyExistsInList = builtLocations.any((existsItem) => existsItem.itemIid == item.itemIid);
        if (alreadyExistsInList == false) {
          builtLocations.add(item);
        }
      } else {
        final parent = locationMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
      }
    }

    return (builtLocations, locationMap);
  }

  Future<(List<Item>, Map<String, LocationEntity>)> buildLocationsToAssetsFilter(List<String> listIds, String companyId, String? search) async {
    final locations = await remoteRepository.getlocationsToFilter(listIds, companyId, search);
    List<Item> builtLocations = [];
    Map<String, LocationEntity> locationMap = {};
    for (var item in locations) {
      locationMap[item.id] = item;
    }
    for (var item in locations) {
      if (item.parentId == null) {
        final alreadyExistsInList = builtLocations.any((existsItem) => existsItem.itemIid == item.itemIid);
        if (alreadyExistsInList == false) {
          builtLocations.add(item);
        }
      } else {
        final parent = locationMap[item.parentId];
        parent != null ? parent.list.add(item) : null;
        builtLocations.add(item);
      }
    }

    return (builtLocations, locationMap);
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
