import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/common/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company/company_details_cubit_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsCubitState> {
  final BuildContext context;

  CompanyDetailsCubit(this.context) : super(CompanyDetailsInitialState());
  final companyRepository = getIt.get<ICompanyRepository>();
  final ValueNotifier<bool> expanded = ValueNotifier(false);

  // Filters
  final ValueNotifier<bool> criticalFilter = ValueNotifier(false);
  final ValueNotifier<bool> sensorEnergyFilter = ValueNotifier(false);

  Future<void> filter({required String companyId, required String? search}) async {
    expanded.value = true;
    if (criticalFilter.value == true || sensorEnergyFilter.value == true || (search != null && search.length >= 3)) {
      final (tree, error) = await companyRepository.filter(
        companyId: companyId,
        searchField: search,
        criticalFilter: criticalFilter.value,
        sensorEnergyFilter: sensorEnergyFilter.value,
      );

      error != null ? emit(CompanyDetailsErrorState()) : emit(CompanyDetailsSuccessState(list: tree, hasFilters: true));
    } else {
      expanded.value = false;
      final (tree, error) = await companyRepository.buildTheTree(companyId: companyId);
      error != null ? emit(CompanyDetailsErrorState()) : emit(CompanyDetailsSuccessState(list: tree, hasFilters: false));
    }
  }

  Future<void> buildTheTree(String companyId) async {
    expanded.value = false;
    emit(CompanyDetailsLoadingState());
    final (tree, error) = await companyRepository.buildTheTree(companyId: companyId);

    if (error != null) {
      emit(CompanyDetailsErrorState());
    } else {
      emit(CompanyDetailsSuccessState(list: tree, hasFilters: false));
    }
  }
}
