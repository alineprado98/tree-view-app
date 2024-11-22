import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company/company_details_cubit.dart';

class SearchInputWidget extends StatefulWidget {
  final String companyId;

  SearchInputWidget({super.key, required this.companyId});

  @override
  State<SearchInputWidget> createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<SearchInputWidget> {
  String? searchValue;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cubit = BlocProvider.of<CompanyDetailsCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: colors.outline),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Ativo ou Local',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onChanged: (value) async {
                if (timer?.isActive ?? false) timer?.cancel();
                timer = Timer(const Duration(milliseconds: 500), () async {
                  searchValue = value;
                  await cubit.filter(companyId: widget.companyId, search: searchValue);
                });
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
                          selectedColor: colors.secondary,
                          showCheckmark: false,
                          selected: isChecked,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colors.outlineVariant,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: Row(
                            children: [
                              Icon(
                                color: isChecked ? colors.surface : colors.outlineVariant,
                                size: 20,
                                Icons.bolt_outlined,
                              ),
                              SizedBox(width: 8),
                              Text('Sensor de Energia',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isChecked ? colors.surface : colors.outlineVariant,
                                  ))
                            ],
                          ),
                          onSelected: (value) async {
                            cubit.sensorEnergyFilter.value = value;
                            await cubit.filter(companyId: widget.companyId, search: searchValue);
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
                          selectedColor: colors.secondary,
                          showCheckmark: false,
                          selected: isChecked,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: colors.outlineVariant, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: Row(
                            children: [
                              Icon(
                                color: isChecked ? colors.surface : colors.outlineVariant,
                                size: 20,
                                Icons.error_outline,
                              ),
                              SizedBox(width: 8),
                              Text('Crítico',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isChecked ? colors.surface : colors.outlineVariant,
                                  ))
                            ],
                          ),
                          onSelected: (value) async {
                            cubit.criticalFilter.value = value;
                            await cubit.filter(companyId: widget.companyId, search: searchValue);
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
