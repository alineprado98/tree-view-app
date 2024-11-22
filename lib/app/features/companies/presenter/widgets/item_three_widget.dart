import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/utils/app_assets.dart';
import 'package:tree_view_app/app/common/widgets/svg_reader_widget.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';
import 'package:tree_view_app/app/features/companies/presenter/widgets/item_node_type_widget.dart';

class ItemThreeWidget extends StatelessWidget {
  final Item node;
  final bool isExpanded;

  const ItemThreeWidget({
    super.key,
    required this.node,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLocation = node is LocationEntity;
    final lastItem = node.list.isEmpty ? true : false;

    return ExpansionTile(
      initiallyExpanded: isExpanded,
      childrenPadding: const EdgeInsets.only(left: 16),
      expandedAlignment: Alignment.bottomLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      trailing: const SizedBox.shrink(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        children: [
          node.list.isNotEmpty
              ? const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                )
              : const SizedBox.shrink(),
          isLocation == true
              ? SvgReaderWidget(path: AppAssets.locationIcon)
              : lastItem == false
                  ? SvgReaderWidget(path: AppAssets.cubeIcon)
                  : SvgReaderWidget(path: AppAssets.vectorIcon, width: 22, height: 22),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              node.itemName,
              style: TextStyle(
                fontSize: 14,
                color: colors.scrim,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ItemNodeTypeWidget(node: node),
          )
        ],
      ),
      children: node.list.isNotEmpty
          ? node.list
              .map((childNode) => ItemThreeWidget(
                    node: childNode,
                    isExpanded: isExpanded,
                  ))
              .toList()
          : [],
    );
  }
}
