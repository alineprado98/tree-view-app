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
    final cubit = BlocProvider.of<CompanyDetailsCubit>(context);
    Future(() => cubit.buildTheTree(widget.companyId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        body: Column(
          children: [
            SearchWidget(companyId: widget.companyId),
            BlocBuilder<CompanyDetailsCubit, CompanyDetailsCubitState>(
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
                  return Flexible(child: LocationWiget(list: state.list));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ));
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

class SearchWidget extends StatefulWidget {
  final String companyId;

  SearchWidget({super.key, required this.companyId});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CompanyDetailsCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEAEEF2),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Ativo ou Local',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.transparent,
              ),
              onChanged: (value) async {
                value.isNotEmpty ? cubit.search.value = value : cubit.search.value = null;
                await cubit.filter(companyId: widget.companyId);
              },
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder(
                  valueListenable: cubit.sensorEnergyFilter,
                  builder: (context, isChecked, _) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15, top: 5),
                      child: FilterChip(
                          backgroundColor: Colors.transparent,
                          selectedColor: Colors.blue.shade500,
                          showCheckmark: false,
                          selected: isChecked,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.blueGrey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: Row(
                            children: [
                              Icon(
                                color: isChecked ? Colors.white : Colors.blueGrey,
                                size: 20,
                                Icons.bolt_outlined,
                              ),
                              SizedBox(width: 8),
                              Text('Sensor de Energia', style: TextStyle(color: isChecked ? Colors.white : Colors.blueGrey))
                            ],
                          ),
                          onSelected: (value) async {
                            cubit.sensorEnergyFilter.value = value;
                            await cubit.filter(companyId: widget.companyId);
                          }),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: cubit.criticalFilter,
                  builder: (context, isChecked, _) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15, top: 5),
                      child: FilterChip(
                          backgroundColor: Colors.transparent,
                          selectedColor: Colors.blue.shade500,
                          showCheckmark: false,
                          selected: isChecked,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.blueGrey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: Row(
                            children: [
                              Icon(
                                color: isChecked ? Colors.white : Colors.blueGrey,
                                size: 20,
                                Icons.error_outline,
                              ),
                              SizedBox(width: 8),
                              Text('Crítico', style: TextStyle(color: isChecked ? Colors.white : Colors.blueGrey))
                            ],
                          ),
                          onSelected: (value) async {
                            cubit.criticalFilter.value = value;
                            await cubit.filter(companyId: widget.companyId);
                          }),
                    );
                  })
            ],
          )
        ],
      ),
    );
  }
}

Widget verifyStatus(Item node) {
  final nodeIsAsset = node.runtimeType == AssetEntity;
  final currentItemIsAsset = (node.type == ItemType.asset && node.currentItem != null);

  if (currentItemIsAsset || nodeIsAsset) {
    final formatted = nodeIsAsset ? node as AssetEntity : node.currentItem as AssetEntity;
    if (formatted.sensorType == AssetSensors.energy) return SvgPicture.asset('assets/svgs/bolt.svg');
    if (formatted.status == AssetStatus.operating) return SvgPicture.asset('assets/svgs/bolt.svg');
    if (formatted.status == AssetStatus.alert) return SvgPicture.asset('assets/svgs/alert.svg');

    return const SizedBox.shrink();
  }
  return const SizedBox.shrink();
}

Widget _buildTile(Item node) {
  final isLocation = node is LocationEntity;

  final lastItem = node.list.isEmpty ? true : false;

  return ExpansionTile(
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
    children: node.list.isNotEmpty ? node.list.map((childNode) => _buildTile(childNode)).toList() : [],
  );
}
