import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/utils/app_assets.dart';
import 'package:tree_view_app/app/common/widgets/svg_reader_widget.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';

class ItemNodeTypeWidget extends StatelessWidget {
  final Item node;
  const ItemNodeTypeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (node is AssetEntity) {
      final item = node as AssetEntity;

      if (item.sensorType == AssetSensors.energy && item.status == AssetStatus.alert) return SvgReaderWidget(path: AppAssets.energyIcon, color: colors.error);
      if (item.sensorType == AssetSensors.energy && item.status == AssetStatus.operating) return SvgReaderWidget(path: AppAssets.energyIcon, color: colors.tertiary);
      if (item.sensorType == AssetSensors.vibration && item.status == AssetStatus.alert) return SvgReaderWidget(path: AppAssets.vibrationIcon, color: colors.error);
      if (item.sensorType == AssetSensors.vibration && item.status == AssetStatus.operating) return SvgReaderWidget(path: AppAssets.vibrationIcon, color: colors.tertiary);
    }
    return const SizedBox.shrink();
  }
}
