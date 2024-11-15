import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/asset_entity.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/local_entity.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company_details_cubit.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company_details_cubit_state.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String companyId;
  const CompanyDetailsPage({super.key, required this.companyId});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  @override
  void initState() {
    Future(() => BlocProvider.of<CompanyDetailsCubit>(context).buildTheTree(widget.companyId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: BlocBuilder<CompanyDetailsCubit, CompanyDetailsCubitState>(
        bloc: BlocProvider.of<CompanyDetailsCubit>(context),
        builder: (context, state) {
          if (state is CompanyDetailsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CompanyDetailsErrorState) {
            return const SizedBox.shrink();
          }
          if (state is CompanyDetailsEmptyState) {
            return const SizedBox.shrink();
          }
          if (state is CompanyDetailsSuccessState) {
            return LocationWiget(list: state.list);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class LocationWiget extends StatelessWidget {
  final List<Item> list;
  const LocationWiget({super.key, required this.list});
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: list.map((node) => _buildTile(node)).toList(),
    );
  }
}

Widget verifyStatus(Item node) {
  final nodeIsAsset = node.runtimeType == AssetEntity;
  final currentItemIsAsset = (node.type == ItemType.asset && node.currentItem != null);

  if (currentItemIsAsset || nodeIsAsset) {
    final formatted = nodeIsAsset ? node as AssetEntity : node.currentItem as AssetEntity;
    if (formatted.sensorType == AssetSensors.energy) return SvgPicture.asset('assets/svgs/bolt.svg');
    // if (formatted.sensorType == AssetSensors.vibration) return SvgPicture.asset('assets/svgs/bolt.svg');
    if (formatted.status == AssetStatus.operating) return SvgPicture.asset('assets/svgs/bolt.svg');
    if (formatted.status == AssetStatus.alert) return SvgPicture.asset('assets/svgs/alert.svg');

    return const SizedBox.shrink();
  }
  return const SizedBox.shrink();
}

Widget _buildTile(Item node) {
  final isLocation = node.currentItem is LocationEntity;

  final lastItem = node.list.isEmpty ? true : false;

  return ExpansionTile(
    childrenPadding: const EdgeInsets.only(left: 16),
    expandedAlignment: Alignment.bottomLeft,
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    trailing: const SizedBox.shrink(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Forma arredondada
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
            ? SvgPicture.asset('assets/svgs/go_location.svg')
            : lastItem == false
                ? SvgPicture.asset('assets/svgs/io_cube_outline.svg')
                : SvgPicture.asset(
                    'assets/svgs/vector.svg',
                    width: 22,
                    height: 22,
                  ),
        Flexible(
          child: Text(
            node.itemName,
            style: const TextStyle(
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: verifyStatus(node),
        )
      ],
    ),
    children: node.list.isNotEmpty ? node.list.map((childNode) => _buildTile(childNode)).toList() : [], // Se não houver filhos, não cria mais ExpansionTiles
  );
}
