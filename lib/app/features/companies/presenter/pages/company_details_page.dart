import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/common/widgets/error_widget.dart';
import 'package:tree_view_app/app/features/companies/presenter/widgets/item_three_widget.dart';
import 'package:tree_view_app/app/features/companies/presenter/widgets/search_input_widget.dart';
import 'package:tree_view_app/app/features/companies/presenter/widgets/empty_state_search_widget.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company/company_details_cubit.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company/company_details_cubit_state.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String companyId;
  const CompanyDetailsPage({super.key, required this.companyId});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future(() => _buildTree());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        body: Column(
          children: [
            SearchInputWidget(companyId: widget.companyId),
            BlocBuilder<CompanyDetailsCubit, CompanyDetailsCubitState>(
              bloc: BlocProvider.of<CompanyDetailsCubit>(context),
              builder: (context, state) {
                if (state is CompanyDetailsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CompanyDetailsErrorState) {
                  return Expanded(child: ErrorStateWidget(onRefresh: _buildTree));
                }
                if (state is CompanyDetailsSuccessState) {
                  print("Novo estad0: ${state.hasFilters}");
                  return Flexible(
                    child: state.list.isEmpty
                        ? EmptyStateSearchWidget()
                        : ListView(
                            shrinkWrap: true,
                            children: state.list
                                .map((node) => ItemThreeWidget(
                                      node: node,
                                      isExpanded: state.hasFilters,
                                    ))
                                .toList(),
                          ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ));
  }

  Future<void> _buildTree() async {
    await BlocProvider.of<CompanyDetailsCubit>(context).buildTheTree(widget.companyId);
  }
}
